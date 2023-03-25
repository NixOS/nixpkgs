{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyatag";
  version = "3.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MatsNl";
    repo = "pyatag";
    rev = "refs/tags/${version}";
    hash = "sha256-hyGos0LFVKv63jf1ODPFfk+R47oyHea+8MGvxeKpop8=";
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
    changelog = "https://github.com/MatsNl/pyatag/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
