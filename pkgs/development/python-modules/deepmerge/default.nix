{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "deepmerge";
  version = "3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FO1p8GPeZLd0OYXHMsz/XWw0/0VglG5/v9mQhrhTuc4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "deepmerge" ];

  meta = {
    changelog = "https://github.com/toumorokoshi/deepmerge/releases/tag/v${version}";
    description = "Toolset to deeply merge python dictionaries";
    downloadPage = "https://github.com/toumorokoshi/deepmerge";
    homepage = "http://deepmerge.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
