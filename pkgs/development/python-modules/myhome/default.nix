{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  python-dateutil,
  urllib3,
}:

buildPythonPackage rec {
  pname = "myhome";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "speijnik";
    repo = "myhome";
    rev = "v${version}";
    hash = "sha256-DJzwvgvSA9Q0kpueUoQV64pdDDNA7WzGu7r+g5aqutk=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "myhome" ];

  meta = {
    description = "Python library for interacting with MyHomeSERVER1";
    homepage = "https://github.com/speijnik/myhome";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
