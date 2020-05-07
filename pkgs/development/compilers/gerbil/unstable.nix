{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support, coreutils, bash }:

callPackage ./build.nix rec {
  version = "unstable-2020-05-17";
  git-version = "0.16-1-g36a31050";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "36a31050f6c80e7e1a49dfae96a57b2ad0260698";
    sha256 = "0k3fypam9qx110sjxgzxa1mdf5b631w16s9p5v37cb8ll26vqfiv";
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
