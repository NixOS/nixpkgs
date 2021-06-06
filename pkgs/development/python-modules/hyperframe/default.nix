{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "hyperframe";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "742d2a4bc3152a340a49d59f32e33ec420aa8e7054c1444ef5c7efff255842f1";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "HTTP/2 framing layer for Python";
    homepage = "http://hyper.rtfd.org/";
    license = licenses.mit;
  };
}
