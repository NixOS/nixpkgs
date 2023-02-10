{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, python-dateutil
, pythonOlder
, urllib3
}:

buildPythonPackage rec {
  pname = "myhome";
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "speijnik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DJzwvgvSA9Q0kpueUoQV64pdDDNA7WzGu7r+g5aqutk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "myhome"
  ];

  meta = with lib; {
    description = "Python library for interacting with MyHomeSERVER1";
    homepage = "https://github.com/speijnik/myhome";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
