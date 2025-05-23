{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,

  # build-system
  poetry-core,

  # nativeCheckInputs
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "pymp4";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beardypig";
    repo = "pymp4";
    rev = "v${version}";
    hash = "sha256-gX9ovkA5+siYXmZ+StyQHRKrqS0NkKw0c/0SeUFcOqU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    # pymp4 (as of v1.4.0) requires exactly v2.8.8 of construct
    (buildPythonPackage rec {
      pname = "construct";
      version = "2.8.8";

      src = fetchPypi {
        inherit pname version;
        hash = "sha256-G4S4FH9v0VvPZLc3w+isUQCBGtgMgwy0slRRQFEcQVc=";
      };
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "MP4 parser and toolkit";
    homepage = "https://github.com/beardypig/pymp4";
    changelog = "https://github.com/beardypig/pymp4/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ valentinegb ];
  };
}
