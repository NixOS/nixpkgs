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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "d-k-bo";
    repo = "televido";
    rev = "v${version}";
    hash = "sha256-pMrMXRnfvpDLFkL2IqYJKRao/OF78mXUCBqBgT97+hc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-wavxkhDS0hspGMw5ZKTxjZ07TiZ67OkbMhicB8h5y64=";
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
