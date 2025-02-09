{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mmh3";
  version = "5.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hajimes";
    repo = "mmh3";
    tag = "v${version}";
    hash = "sha256-no3wbBxEz1UPiN25HvZGAUV1QxZydJB0Hb2Ib9ZrAUY=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "mmh3" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python wrapper for MurmurHash3, a set of fast and robust hash functions";
    homepage = "https://github.com/hajimes/mmh3";
    changelog = "https://github.com/hajimes/mmh3/blob/v${version}/CHANGELOG.md";
    license = licenses.cc0;
    maintainers = [ ];
  };
}
