{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, lxml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysaj";
  version = "0.0.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fredericvl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7mN6GPRbXfEUfCrCrCs71SSt4x2Ch2y3a5rfXnuwVA0=";
  };

  propagatedBuildInputs = [
    aiohttp
    lxml
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pysaj"
  ];

  meta = with lib; {
    description = "Library to communicate with SAJ inverters";
    homepage = "https://github.com/fredericvl/pysaj";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
