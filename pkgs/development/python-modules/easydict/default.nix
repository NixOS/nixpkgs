{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "easydict";
  version = "1.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Edyywgqqu/7kwYi0vBQ+9r4ESzTb8M5aWTJCwmlaCA8=";
  };

  doCheck = false; # No tests in archive

  pythonImportsCheck = [
    "easydict"
  ];

  meta = with lib; {
    homepage = "https://github.com/makinacorpus/easydict";
    license = licenses.lgpl3;
    description = "Access dict values as attributes (works recursively)";
  };
}
