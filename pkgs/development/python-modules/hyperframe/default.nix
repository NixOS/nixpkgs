{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hyperframe";
  version = "6.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rlEARiMdyOnssaZYb2PSNHv0yJBZFKqEulha6F8oqRQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyperframe" ];

  meta = with lib; {
    description = "HTTP/2 framing layer for Python";
    homepage = "https://github.com/python-hyper/hyperframe/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
