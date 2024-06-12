{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, cargo
, wrapGAppsHook4
, blueprint-compiler
, libadwaita
, desktop-file-utils
, openssl
}:

stdenv.mkDerivation rec {
  pname = "televido";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "d-k-bo";
    repo = "televido";
    rev = "v${version}";
    hash = "sha256-qfUwPyutBNEnplD3kmTJXffzcWkEcR6FTLnT5YDSysU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-CmQQH6a5xMq+v+P4/sbpQ7iDaGKtzV39FgufD5uxz4Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    cargo
    wrapGAppsHook4
    blueprint-compiler
    openssl
  ];

  buildInputs = [
    libadwaita
    desktop-file-utils
  ];

  meta = with lib; {
    description = "Viewer for German-language public broadcasting live streams and archives";
    homepage = "https://github.com/d-k-bo/televido";
    license = licenses.gpl3;
    mainProgram = "televido";
    maintainers = with maintainers; [ seineeloquenz ];
    platforms = platforms.linux;
  };
}
