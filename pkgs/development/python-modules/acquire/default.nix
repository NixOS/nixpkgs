{
  lib,
  buildPythonPackage,
  defusedxml,
  dissect-cstruct,
  dissect-target,
  fetchFromGitHub,
  minio,
  pycryptodome,
  pytestCheckHook,
  requests,
  requests-toolbelt,
  rich,
  setuptools,
  setuptools-scm,
}:
let
  fullDeps = [
    dissect-target
    minio
    pycryptodome
    requests
    requests-toolbelt
    rich
  ]
  ++ dissect-target.optional-dependencies.full;
in
buildPythonPackage (finalAttrs: {
  pname = "acquire";
  version = "3.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "acquire";
    tag = finalAttrs.version;
    hash = "sha256-CtzVHnQALqA5D0wJQ74lAw9HunVFZEkKvij6RQaQrBE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    defusedxml
    dissect-cstruct
    dissect-target
  ];

  optional-dependencies = {
    full = fullDeps;
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ fullDeps;

  disabledTests = [
    "output_encrypt"
    "test_collector_collect_glob"
    "test_collector_collect_path_with_dir"
    "test_misc_osx"
    "test_misc_unix"
  ];

  pythonImportsCheck = [ "acquire" ];

  meta = {
    description = "Tool to quickly gather forensic artifacts from disk images or a live system";
    homepage = "https://github.com/fox-it/acquire";
    changelog = "https://github.com/fox-it/acquire/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
