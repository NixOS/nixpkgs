{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jcrist";
    repo = "msgspec";
    tag = version;
    hash = "sha256-g2yhw9fMucBHlGx9kAMQL87znXlQT9KbxQ/QcmUetqI=";
  };

  build-system = [ setuptools ];

  # Requires libasan to be accessible
  doCheck = false;

  pythonImportsCheck = [ "msgspec" ];

  meta = {
    description = "Module to handle JSON/MessagePack";
    homepage = "https://github.com/jcrist/msgspec";
    changelog = "https://github.com/jcrist/msgspec/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
