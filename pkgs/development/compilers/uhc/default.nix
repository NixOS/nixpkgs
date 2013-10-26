{ stdenv, coreutils, glibc, fetchgit, m4, libtool, ghc, uulib
, uuagc, mtl, network, binary, llvm, fgl, syb
}:

# this check won't be needed anymore after ghc-wrapper is fixed
# to show ghc-builtin packages in "ghc-pkg list" output.
let binaryIsBuiltIn = builtins.compareVersions "7.2.1" ghc.version != 1;

in stdenv.mkDerivation {
  name = "uhc-svn-git20120502";

  src = fetchgit {
     url = "https://github.com/UU-ComputerScience/uhc.git";
     rev = "ab26d787657bb729d8a4f92ef5d067d9990f6ce3";
     sha256 = "66c5b6d95dc80a652f6e17476a1b18fbef4b4ff6199a92d033f0055526ec97ff";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/EHC";

  propagatedBuildInputs = [mtl network binary fgl syb];
  buildInputs = [coreutils m4 ghc libtool uulib uuagc];

  # Can we rename this flag to "--with-cpp-uhc-options"?
  configureFlags = "--with-cpp-ehc-options=-I${glibc}/include";

  # UHC builds packages during compilation; these are by default
  # installed in the user-specific package config file. We do not
  # want that, and hack the build process to use a temporary package
  # configuration file instead.
  preConfigure = ''
    p=`pwd`/uhc-local-packages
    echo '[]' > $p
    sed -i "s|--user|--package-db=$p|g" mk/shared.mk.in
    sed -i "s|-fglasgow-exts|-fglasgow-exts -package-conf=$p|g" mk/shared.mk.in
    sed -i "s|/bin/date|${coreutils}/bin/date|g" mk/dist.mk
    sed -i "s|/bin/date|${coreutils}/bin/date|g" mk/config.mk.in
  '' + stdenv.lib.optionalString binaryIsBuiltIn ''
    sed -i "s|ghcLibBinary=no|ghcLibBinaryExists=yes|" configure
  '';

  meta = {
    homepage = "http://www.cs.uu.nl/wiki/UHC";
    description = "Utrecht Haskell Compiler";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [
      stdenv.lib.maintainers.andres
    ];
  };
}
