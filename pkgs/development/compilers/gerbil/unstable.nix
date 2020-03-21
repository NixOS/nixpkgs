{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support, coreutils, bash }:

callPackage ./build.nix {
  version = "unstable-2020-02-27";
  git-version = "0.16-DEV-493-g1ffb74db";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "1ffb74db5ffd49b4bad751586cef5e619c891d41";
    sha256 = "1szmdp8lvy5gpcwn5bpa7x383m6vywl35xa7hz9a5vs1rq4w2097";
  };
  inherit gambit-support;
  gambit = gambit-unstable;
  gambit-params = gambit-support.unstable-params;
  configurePhase = ''
    (cd src && ./configure \
      --prefix=$out/gerbil \
      --with-gambit=${gambit}/gambit \
      --enable-libxml \
      --enable-libyaml \
      --enable-zlib \
      --enable-sqlite \
      --enable-mysql \
      --enable-lmdb \
      --enable-leveldb)
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/gerbil $out/bin
    (cd src; ./install)
    (cd $out/bin ; ln -s ../gerbil/bin/* .)
    runHook postInstall
  '';
}
