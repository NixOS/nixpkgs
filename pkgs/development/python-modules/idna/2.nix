{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "idna";
  version = "2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6";
  };

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}
