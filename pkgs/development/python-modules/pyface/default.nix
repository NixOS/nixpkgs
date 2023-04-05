{ lib
, fetchPypi
, buildPythonPackage
, importlib-metadata
, importlib-resources
, traits
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyface";
  version = "7.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0F+qxFOUvVWYWQahIM8AEv58rCxmNJYsBTC2pjUO2yI=";
  };

  propagatedBuildInputs = [
    importlib-metadata
    importlib-resources
    traits
  ];

  doCheck = false; # Needs X server

  pythonImportsCheck = [
    "pyface"
  ];

  meta = with lib; {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/pyface";
    changelog = "https://github.com/enthought/pyface/releases/tag/${version}";
    maintainers = with maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
