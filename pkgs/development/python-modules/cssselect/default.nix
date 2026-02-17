{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  lxml,
}:

buildPythonPackage rec {
  pname = "cssselect";
  version = "1.3.0";
  pyproject = true;

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

  meta = {
    description = "CSS Selectors for Python";
    homepage = "https://cssselect.readthedocs.io/";
    changelog = "https://github.com/scrapy/cssselect/v${version}//CHANGES";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
