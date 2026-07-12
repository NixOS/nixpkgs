{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gdal,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "t-rex";
  version = "0.15.0-alpha3";

  src = fetchFromGitHub {
    owner = "t-rex-tileserver";
    repo = "t-rex";
    rev = "v${version}";
    hash = "sha256-oZZrR86/acoyMX3vC1JGrpc8G+DEuplqfEAnaP+TBGU=";
  };

  cargoHash = "sha256-z0YpX1dMWcn2N6fKDbT7lYEQC5PaDNNHi4CW88d/dgI=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gdal
    openssl
  ];

  meta = {
    description = "Vector tile server specialized on publishing MVT tiles";
    homepage = "https://t-rex.tileserver.ch/";
    changelog = "https://github.com/t-rex-tileserver/t-rex/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
    mainProgram = "t_rex";
    platforms = lib.platforms.unix;
    broken = true; # see https://github.com/t-rex-tileserver/t-rex/issues/320
  };
}
