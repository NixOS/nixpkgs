{ stdenv, coreutils, glibc, fetchgit, m4, libtool, ghc, uulib
, uuagc, mtl, network, binary, llvm, fgl, syb
}:

stdenv.mkDerivation {
  name = "uhc-svn-git20120412";

  src = fetchgit {
     url = "https://github.com/UU-ComputerScience/uhc.git";
     rev = "eef10f64d84bc0aa145121f2a61accea03b9bc76";
     sha256 = "c867d22423adb17396a28eef030c53f282b1443db2149aa7b8ab659ac7c18576";
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
