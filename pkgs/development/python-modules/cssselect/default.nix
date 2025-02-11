{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  lxml,
}:

buildPythonPackage rec {
  pname = "cssselect";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
  ];

  pythonImportsCheck = [ "cssselect" ];

  meta = with lib; {
    description = "CSS Selectors for Python";
    homepage = "https://cssselect.readthedocs.io/";
    changelog = "https://github.com/scrapy/cssselect/v${version}//CHANGES";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
