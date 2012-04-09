{ stdenv, coreutils, glibc, fetchgit, m4, libtool, ghc, uulib
, uuagc, mtl, network, binary, llvm, fgl, syb
}:

stdenv.mkDerivation {
  name = "uhc-svn-git20120405";

  src = fetchgit {
     url = "https://github.com/UU-ComputerScience/uhc.git";
     rev = "d6d75a131a36899ff2db2d8c9a4ae6601d7d0675";
     sha256 = "4117688bf1e4a892d8551c3bcc59c5ec5743842e6a67ec66d399f390fec05b4c";
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
  '';

  meta = {
    homepage = "http://www.cs.uu.nl/wiki/UHC";
    description = "Utrecht Haskell Compiler";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [
      stdenv.lib.maintainers.andres
      stdenv.lib.maintainers.simons
    ];
  };
}
