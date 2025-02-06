{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gdal,
  openssl,
  darwin,
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

  cargoHash = "sha256-nxq4mX2Sy6Hyi8tA2CQsQwISB/kau4DEkAgIm4SvGns=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gdal
    openssl
  ] ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description = "Vector tile server specialized on publishing MVT tiles";
    homepage = "https://t-rex.tileserver.ch/";
    changelog = "https://github.com/t-rex-tileserver/t-rex/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = teams.geospatial.members;
    mainProgram = "t_rex";
    platforms = platforms.unix;
    broken = true; # see https://github.com/t-rex-tileserver/t-rex/issues/320
  };
}
