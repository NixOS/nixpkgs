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
  version = "3.1.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ajinabraham";
    repo = "libsast";
    tag = finalAttrs.version;
    hash = "sha256-A02VcSgd58m7ZomvAz0TBEe8hRZhx29jAjYl48fwPKg=";
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
