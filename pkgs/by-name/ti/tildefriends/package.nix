{ lib
, stdenv
, fetchFromGitea
, gnumake
, openssl
, which
}:

stdenv.mkDerivation rec {
  pname = "tildefriends";
  version = "0.0.17";

  src = fetchFromGitea {
    domain = "dev.tildefriends.net";
    owner = "cory";
    repo = "tildefriends";
    rev = "v${version}";
    hash = "sha256-Wc9MvafA2rPmjnRvmMB3qmRyDQNhF688weKItHw3E8I=";
  };

  nativeBuildInputs = [
    gnumake
    openssl
    which
  ];

  buildPhase = ''
    make -j $NIX_BUILD_CORES release
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp -r out/release/* $out/bin
  '';

  doCheck = false;

  meta = {
    homepage = "https://tildefriends.net";
    description = "Make apps and friends from the comfort of your web browser.";
    mainProgram = "tildefriends";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ tasiaiso ];
    platforms = lib.platforms.all;
  };
}
