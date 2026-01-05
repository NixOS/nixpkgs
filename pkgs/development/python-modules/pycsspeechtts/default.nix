{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  requests,
}:

buildPythonPackage rec {
  pname = "pycsspeechtts";
  version = "1.0.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kgof0T22VRU96pKAWuEBo56F6t7o2X/xRS/L5B7UYDY=";
  };

  build-system = [ hatchling ];

  dependencies = [ requests ];

  # Tests require API key and network access
  doCheck = false;

  pythonImportsCheck = [ "pycsspeechtts" ];

  meta = {
    description = "Python library for Microsoft Cognitive Services Text-to-Speech";
    homepage = "https://github.com/jeroenterheerdt/pycsspeechtts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
