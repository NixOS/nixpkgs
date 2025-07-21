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
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-V/iplCTPqyiaG2qBakMHWksAlIyGtNzz707n4V96sMc=";
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
