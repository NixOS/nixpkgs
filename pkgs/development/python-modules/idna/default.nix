{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "idna";
  version = "3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5b02147e01ea9920e6b0a3f1f7bb833612d507592c837a6c49552768f4054e1";
  };

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}
