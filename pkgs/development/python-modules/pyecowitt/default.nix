{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyecowitt";
  version = "0.21";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "garbled1";
    repo = pname;
    rev = version;
    sha256 = "5VdVo6j2HZXSCWU4NvfWzyS/KJfVb7N1KSMeu8TvWaQ=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project thas no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyecowitt"
  ];

  meta = with lib; {
    description = "Python module for the EcoWitt Protocol";
    homepage = "https://github.com/garbled1/pyecowitt";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
