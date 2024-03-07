{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "easydict";
  version = "1.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3LHS7SjrMAyORs03E0A3Orxi98FNbep0/fxvEGkGHHg=";
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
