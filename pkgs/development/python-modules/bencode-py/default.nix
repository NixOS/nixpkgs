{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pbr,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bencode-py";
  version = "4.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fuzeman";
    repo = "bencode.py";
    tag = finalAttrs.version;
    hash = "sha256-vUG8QwcI34uFo7aldDhQORoZuuI/CYGoSOdSfGmj2uQ=";
  };

  build-system = [
    setuptools
    pbr
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bencodepy" ];

  disabledTests = [
    # Failed: DID NOT RAISE BencodeDecodeError
    "test_decode_recursion_error"
    "test_read_recursion_error"
  ];

  meta = {
    description = "Simple bencode parser (for Python 2, Python 3 and PyPy)";
    homepage = "https://github.com/fuzeman/bencode.py";
    changelog = "https://github.com/fuzeman/bencode.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bitTorrent11;
    maintainers = with lib.maintainers; [ vamega ];
  };
})
