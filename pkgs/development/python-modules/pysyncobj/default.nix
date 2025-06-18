{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pysyncobj";
  version = "0.3.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bakwc";
    repo = "PySyncObj";
    tag = "v${version}";
    hash = "sha256-a1fECsLIEFu9Wwai0viR/lkqWVWBKs+OdxHey3Pltmo=";
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
