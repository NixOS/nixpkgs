{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "editables";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6918f16225258f24ef9800c2327e14eded42ddac344e77982380749464024f35";
  };

  checkInputs = [
    pytestCheckHook
  ];

  # Tests not included in archive.
  doCheck = false;

  meta = {
    description = "Editable installations";
    homepage = https://github.com/pfmoore/editables;
    license = lib.licenses.mit;
  };
}
