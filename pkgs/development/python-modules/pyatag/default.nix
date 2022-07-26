{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, aiohttp
}:

buildPythonPackage rec {
  pname = "pyatag";
  version = "3.5.1";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "MatsNl";
    repo = "pyatag";
    rev = version;
    sha256 = "17x2m7icbby1y2zfc79jpbir2kvyqlrkix9pvvxanm658arsh8c7";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pyatag"
    "pyatag.discovery"
  ];

  meta = with lib; {
    description = "Python module to talk to Atag One";
    homepage = "https://github.com/MatsNl/pyatag";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
