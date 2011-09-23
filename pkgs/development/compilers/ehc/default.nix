{ stdenv, coreutils, glibc, fetchsvn, m4, libtool, ghc, uulib
, uuagc, mtl, network, binary, llvm, fgl, syb
}:

let
  revision = "2293";
in
stdenv.mkDerivation {
  name = "ehc-svn-${revision}";

  src = fetchsvn {
     url = https://subversion.cs.uu.nl/repos/project.UHC.pub/trunk/EHC;
     rev = revision;
     sha256 = "f4c3d83734cffd64b11e31637598330271a2bb8d2573235d063b27b2ef5f76b6";
  };

  propagatedBuildInputs = [mtl network binary fgl syb];
  buildInputs = [coreutils m4 ghc libtool uulib uuagc];

  configureFlags = "--with-cpp-ehc-options=-I${glibc}/include";

  # EHC builds packages during compilation; these are by default
  # installed in the user-specific package config file. We do not
  # want that, and hack the build process to use a temporary package
  # configuration file instead.
  preConfigure = ''
    p=`pwd`/ehc-local-packages
    echo '[]' > $p
    sed -i "s|--user|--package-db=$p|g" mk/shared.mk.in
    sed -i "s|-fglasgow-exts|-fglasgow-exts -package-conf=$p|g" mk/shared.mk.in
    sed -i "s|/bin/date|${coreutils}/bin/date|g" mk/dist.mk
  '';

  meta = {
    homepage = "http://www.cs.uu.nl/wiki/Ehc/WebHome";
    description = "Essential Haskell Compiler";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [
      stdenv.lib.maintainers.andres
      stdenv.lib.maintainers.simons
    ];
  };
}
