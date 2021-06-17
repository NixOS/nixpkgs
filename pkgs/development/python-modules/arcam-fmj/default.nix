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
  version = "0.7.0";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "arcam_fmj";
    rev = version;
    sha256 = "0y4wvvbcsizjd9qz6iw4gjhq5qf0qcqs27hpx1cd90vhy6rclxm0";
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
