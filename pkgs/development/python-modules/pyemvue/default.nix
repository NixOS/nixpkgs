{ lib
, buildPythonPackage
, fetchPypi

# build-system
, hatchling

# propagated modules
, requests
, dateutil
, python-jose
, pycognito
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pyemvue";
  version = "0.18.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s1Uuoiog3OkqOb6PSTqh79vgyLDGFIuZMCyQKH+qG3g=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    requests
    python-dateutil
    pycognito
    typing-extensions
  ];

  pythonImportsCheck = [ "pyemvue" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "A Python Library for reading data from the Emporia Vue energy monitoring system.";
    homepage = "https://github.com/magico13/PyEmVue";
    license = licenses.mit;
    maintainers = with maintainers; [ presto8 ];
  };
}
