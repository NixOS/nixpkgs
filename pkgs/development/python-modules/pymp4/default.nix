{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,
}:
buildPythonPackage rec {
  pname = "pymp4";
  version = "1.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vJ53cyqKFD00w4qoYqVBgHFiRpOOS/PgdYXRklK3e7U=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    (buildPythonPackage rec {
      pname = "construct";
      version = "2.8.8";

      src = fetchPypi {
        inherit pname version;
        hash = "sha256-G4S4FH9v0VvPZLc3w+isUQCBGtgMgwy0slRRQFEcQVc=";
      };
    })
  ];

  meta = {
    description = "MP4 parser and toolkit";
    homepage = "https://github.com/beardypig/pymp4";
    changelog = "https://github.com/beardypig/pymp4/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ valentinegb ];
  };
}
