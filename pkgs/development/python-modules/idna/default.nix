{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "idna";
  version = "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d";
  };

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}
