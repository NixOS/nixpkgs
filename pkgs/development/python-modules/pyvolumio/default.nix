{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvolumio";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "PyVolumio";
    rev = "v${version}";
    sha256 = "1nyvflap39cwq1cm9wwl9idvfmz1ixsl80f1dnskx22fk0lmvj4h";
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
