{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvolumio";
  version = "0.1.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "PyVolumio";
    rev = "v${version}";
    sha256 = "0x2dzmd9lwnak2iy6v54y24qjq37y3nlfhsvx7hddgv8jj1klvap";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyvolumio" ];

  meta = with lib; {
    description = "Python module to control Volumio";
    homepage = "https://github.com/OnFreund/PyVolumio";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
