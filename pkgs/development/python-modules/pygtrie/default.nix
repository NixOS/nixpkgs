{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "pygtrie";
  version = "2.5.0";

  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "pygtrie";
    inherit (finalAttrs) version;
    hash = "sha256-IDUUrYJutAPasdLi3dA04NFTS75NvgITuwWT9mvrpOI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test.py" ];

  meta = {
    homepage = "https://github.com/mina86/pygtrie";
    description = "Trie data structure implementation";
    changelog = "https://github.com/mina86/pygtrie/blob/v${finalAttrs.version}/version-history.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kmein ];
  };
})
