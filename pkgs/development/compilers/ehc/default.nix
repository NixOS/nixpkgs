{stdenv, coreutils, glibc, fetchsvn, m4, libtool, ghc, uulib, uuagc, mtl, network, binary, llvm, fgl}:

stdenv.mkDerivation (rec {
  revision = "1996";
  name = "ehc-svn-${revision}";
  homepage = "http://www.cs.uu.nl/wiki/Ehc/WebHome/";

  src = fetchsvn {
          url = https://subversion.cs.uu.nl/repos/project.UHC.pub/trunk/EHC;
          rev = revision;
          sha256 = "92c658cd15dd513ccaeb81341f2680056276a46d053330f66c0214d10a6729e2";
  };

  propagatedBuildInputs = [mtl network binary fgl];
  buildInputs = [coreutils m4 ghc libtool uulib uuagc];

  # --force is required because the dependencies are not properly
  # detected by Nix, being located in several package config files
  configureFlags = [
    "--with-cabal-config-options=--ghc-pkg-options=--force"
    "--with-cpp-ehc-options=-I${glibc}/include"
  ];

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
    description = "Essential Haskell Compiler";
  };

  inherit coreutils;
})
