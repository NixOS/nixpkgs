{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  poetry-core,
  billiard,
  pyyaml,
  requests,
  pytestCheckHook,
  semgrep,
}:

buildPythonPackage (finalAttrs: {
  pname = "libsast";
  version = "3.1.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ajinabraham";
    repo = "libsast";
    tag = finalAttrs.version;
    hash = "sha256-PG4rA+13CKp9JT1rPvQZp1DWIcLL37NOWRRs/vB/bGE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    poetry-core
    billiard
    pyyaml
    requests
  ];

  pythonImportsCheck = [ "libsast" ];

  nativeCheckInputs = [
    pytestCheckHook
    semgrep
  ];

  disabledTests = [
    # requires internet
    "test_load_url"
    "test_semgrep"
  ];

  meta = {
    description = "Generic SAST Library";
    homepage = "https://github.com/ajinabraham/libsast";
    changelog = "https://github.com/ajinabraham/libsast/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
