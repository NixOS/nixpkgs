{ stdenv, coreutils, glibc, fetchsvn, m4, libtool, ghc, uulib
, uuagc, mtl, network, binary, llvm, fgl, syb
}:

let
  revision = "2375";
in
stdenv.mkDerivation {
  name = "uhc-svn-${revision}";

  src = fetchsvn {
     url = "https://subversion.cs.uu.nl/repos/project.UHC.pub/trunk/EHC";
     rev = revision;
     sha256 = "bde79664b7d04337ce668eab63291702687e6d572a302111425e5ff870c57619";
  };

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
