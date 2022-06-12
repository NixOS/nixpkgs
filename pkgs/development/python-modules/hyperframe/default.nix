{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "hyperframe";
  version = "6.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyperframe" ];

  meta = with lib; {
    description = "HTTP/2 framing layer for Python";
    homepage = "https://github.com/python-hyper/hyperframe/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
