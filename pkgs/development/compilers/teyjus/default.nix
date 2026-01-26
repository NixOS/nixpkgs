{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  stdenv,
  flex,
  bison,
}:

(buildDunePackage.override { inherit stdenv; }) (finalAttrs: {
  pname = "teyjus";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "teyjus";
    repo = "teyjus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N4XKDd0NFr501PYUdb7PM2sWh0uD1/SUFXoMr10f064=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    flex
    bison
  ];

  hardeningDisable = [ "format" ];

  doCheck = true;

  meta = {
    description = "Efficient implementation of the Lambda Prolog language";
    homepage = "https://github.com/teyjus/teyjus";
    changelog = "https://github.com/teyjus/teyjus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bcdarwin ];
    platforms = lib.platforms.unix;
  };
})
