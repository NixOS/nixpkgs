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
  version = "2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XD2GCB++vQTdXeA2JqBge4CamPtsy6V3C2JGb+lA/yA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "deepmerge" ];

  meta = with lib; {
    changelog = "https://github.com/toumorokoshi/deepmerge/releases/tag/v${version}";
    description = "Toolset to deeply merge python dictionaries";
    downloadPage = "https://github.com/toumorokoshi/deepmerge";
    homepage = "http://deepmerge.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
