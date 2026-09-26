{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pbr,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "bencode-py";
  version = "4.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "bencode.py";
    hash = "sha256-KiTM2hclpRplCJPQtjJgE4NZ6qKZu256CZYTUKKm4Fw=";
  };

  build-system = [
    setuptools
    pbr
  ];

  pythonImportsCheck = [ "bencodepy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Simple bencode parser (for Python 2, Python 3 and PyPy)";
    homepage = "https://github.com/fuzeman/bencode.py";
    license = lib.licenses.bitTorrent11;
    maintainers = with lib.maintainers; [ vamega ];
  };
})
