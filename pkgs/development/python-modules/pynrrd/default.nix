{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  numpy,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pynrrd";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mhe";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-B/G46/9Xf1LRu02p0X4/UeW1RYotSXKXRO9VZDPhkNU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nrrd" ];

  meta = {
    homepage = "https://github.com/mhe/pynrrd";
    description = "Simple pure-Python reader for NRRD files";
    changelog = "https://github.com/mhe/pynrrd/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
