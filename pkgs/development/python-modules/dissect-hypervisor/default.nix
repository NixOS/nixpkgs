{
  lib,
  buildPythonPackage,
  defusedxml,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  fetchpatch2,
  pycryptodome,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "dissect-hypervisor";
  version = "3.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.hypervisor";
    tag = finalAttrs.version;
    hash = "sha256-/b/7u3b0G3XRqXxjyhHn5dYzueQOPoacYGeDYv21I0w=";
  };

  patches = [
    # Fix vmtar compat with python 3.13.13+ tarfile refactor.
    (fetchpatch2 {
      url = "https://github.com/fox-it/dissect.hypervisor/commit/8baa8f6ac1ae9a7cfd99095472d9f8e933d290f5.patch?full_index=1";
      excludes = [ "tests/util/test_vmtar.py" ];
      hash = "sha256-Ot0rV1j+yQrXi7v1ARX+Pamnbr+/Q7T1YidY80QdgDo=";
    })
  ];

  postPatch = ''
    substituteInPlace tests/util/test_vmtar.py \
      --replace-fail '"test/file1",' '"test", "test/file1",'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    defusedxml
    dissect-cstruct
    dissect-util
  ];

  optional-dependencies = {
    full = [
      pycryptodome
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.hypervisor" ];

  disabledTests = [
    # Read error
    "test_vmtar"
  ];

  meta = {
    description = "Dissect module implementing parsers for various hypervisor disk, backup and configuration files";
    homepage = "https://github.com/fox-it/dissect.hypervisor";
    changelog = "https://github.com/fox-it/dissect.hypervisor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
