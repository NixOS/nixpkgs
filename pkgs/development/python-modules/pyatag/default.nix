{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, aiohttp
}:

buildPythonPackage rec {
  pname = "pyatag";
  version = "0.3.5.3";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "MatsNl";
    repo = "pyatag";
    rev = version;
    sha256 = "00ly4injmgrj34p0lyx7cz2crgnfcijmzc0540gf7hpwha0marf6";
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
