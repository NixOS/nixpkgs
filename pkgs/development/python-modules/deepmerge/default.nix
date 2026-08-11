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
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B8p6e4k131lsUS+oFhh3wEh6xh9pHAd2bn1x0rI73S8=";
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
