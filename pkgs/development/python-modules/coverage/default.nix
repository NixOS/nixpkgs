{ lib
, buildPythonPackage
, fetchPypi
, mock
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "coverage";
  version = "7.4.3";
  pyproject = true;

  # uses f strings
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J29gd6XGFEekjRM+0T51nAnmKv8NyEJ0po3BhmAQTVI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # No tests in archive
  doCheck = false;
  nativeCheckInputs = [ mock ];

  meta = {
    description = "Code coverage measurement for python";
    homepage = "https://coverage.readthedocs.io/";
    license = lib.licenses.bsd3;
  };
}
