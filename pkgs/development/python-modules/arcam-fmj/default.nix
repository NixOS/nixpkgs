{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, attrs
, defusedxml
, pytest-aiohttp
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "arcam-fmj";
  version = "1.0.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "arcam_fmj";
    rev = version;
    hash = "sha256-MtxUBKv8YgQO817U0u/SqPZQsL0nIXvfdtR+1wlF8DU=";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    defusedxml
  ];

  checkInputs = [
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "arcam.fmj"
    "arcam.fmj.client"
    "arcam.fmj.state"
    "arcam.fmj.utils"
  ];

  meta = with lib; {
    description = "Python library for speaking to Arcam receivers";
    homepage = "https://github.com/elupus/arcam_fmj";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
