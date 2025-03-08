{
  lib,
  aiohttp,
  aiounittest,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyfronius";
  version = "0.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "pyfronius";
    tag = version;
    hash = "sha256-ewU1NubcL9LAWIH3fO/joHJKb7mAw+4u+BWGcq3GAnQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aiounittest
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyfronius" ];

  meta = with lib; {
    description = "Python module to communicate with Fronius Symo";
    homepage = "https://github.com/nielstron/pyfronius";
    changelog = "https://github.com/nielstron/pyfronius/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
