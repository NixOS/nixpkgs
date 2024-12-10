{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  flex,
  bison,
}:

buildDunePackage rec {
  pname = "teyjus";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "teyjus";
    repo = "teyjus";
    rev = "refs/tags/v${version}";
    hash = "sha256-N4XKDd0NFr501PYUdb7PM2sWh0uD1/SUFXoMr10f064=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    flex
    bison
  ];

  hardeningDisable = [ "format" ];

  doCheck = true;

  meta = with lib; {
    description = "An efficient implementation of the Lambda Prolog language";
    homepage = "https://github.com/teyjus/teyjus";
    changelog = "https://github.com/teyjus/teyjus/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = [ maintainers.bcdarwin ];
    platforms = platforms.unix;
  };
}
