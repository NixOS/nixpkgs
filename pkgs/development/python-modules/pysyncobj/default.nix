{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysyncobj";
  version = "0.3.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bakwc";
    repo = "PySyncObj";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZWzvvv13g/iypm+MIl5q0Y8ekqzZEY5upSTPk3MFTPI=";
  };

  build-system = [ setuptools ];

  # Tests require network features
  doCheck = false;

  pythonImportsCheck = [ "pysyncobj" ];

  meta = with lib; {
    description = "Python library for replicating your class";
    homepage = "https://github.com/bakwc/PySyncObj";
    changelog = "https://github.com/bakwc/PySyncObj/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "syncobj_admin";
  };
}
