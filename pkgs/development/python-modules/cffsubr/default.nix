{ lib
, buildPythonPackage
, fetchPypi
, fonttools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cffsubr";
  version = "0.2.9.post1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "azFBLc9JyPqEZkvahn4u3cVbb+b6aW/yU8TxOp/y/Fw=";
  };

  propagatedBuildInputs = [
    fonttools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Standalone CFF subroutinizer based on AFDKO tx";
    homepage = "https://github.com/adobe-type-tools/cffsubr";
    license = licenses.asl20;
  };
}
