{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
}:

buildPythonPackage rec {
  pname = "pysaj";
  version = "0.0.16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fredericvl";
    repo = "pysaj";
    rev = "v${version}";
    hash = "sha256-7mN6GPRbXfEUfCrCrCs71SSt4x2Ch2y3a5rfXnuwVA0=";
  };

  propagatedBuildInputs = [
    aiohttp
    lxml
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysaj" ];

  meta = {
    description = "Library to communicate with SAJ inverters";
    homepage = "https://github.com/fredericvl/pysaj";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
