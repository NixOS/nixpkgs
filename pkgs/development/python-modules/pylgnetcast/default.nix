{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylgnetcast";
  version = "0.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Drafteed";
    repo = "python-lgnetcast";
    rev = "v${version}";
    sha256 = "11g7ya4ppqxjiv3fkz9mi6h1afw9icy6xyn4jzm63kjvxqhrwnw4";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pylgnetcast"
  ];

  meta = with lib; {
    description = "Python API client for the LG Smart TV running NetCast 3 or 4";
    homepage = "https://github.com/Drafteed/python-lgnetcast";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
