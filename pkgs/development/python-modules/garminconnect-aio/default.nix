{ lib
, aiohttp
, brotlipy
, buildPythonPackage
, fetchFromGitHub
, yarl
}:

buildPythonPackage rec {
  pname = "garminconnect-aio";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect-aio";
    rev = version;
    sha256 = "0s2gpy5hciv9akqqhxy0d2ywp6jp9mmdngx34q7fq3xn668kcrhr";
  };

  propagatedBuildInputs = [
    aiohttp
    brotlipy
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "garminconnect_aio" ];

  meta = with lib; {
    description = "Python module to interact with Garmin Connect";
    homepage = "https://github.com/cyberjunky/python-garminconnect-aio";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
