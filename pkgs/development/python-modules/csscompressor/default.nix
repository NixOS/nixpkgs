{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "csscompressor";
  version = "0.9.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-r6IrrbzzEgpPOS5NIvn/9IXARKH+2kqVDsxeup3TGgU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python port of YUI CSS Compressor";
    homepage = "https://pypi.org/project/csscompressor/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
