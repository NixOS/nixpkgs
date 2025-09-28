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
  pythonOlder,
  requests,
  requests-toolbelt,
  rich,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "acquire";
  version = "3.20";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "acquire";
    tag = version;
    hash = "sha256-BfY7LKSP82QnRz3QdfUNFvz7epw5RwGT/H2S43MSvVk=";
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
    full = [
      dissect-target
      minio
      pycryptodome
      requests
      requests-toolbelt
      rich
    ]
    ++ dissect-target.optional-dependencies.full;
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.full;

  disabledTests = [
    "output_encrypt"
    "test_collector_collect_glob"
    "test_collector_collect_path_with_dir"
    "test_misc_osx"
    "test_misc_unix"
  ];

  pythonImportsCheck = [ "acquire" ];

  meta = with lib; {
    description = "Tool to quickly gather forensic artifacts from disk images or a live system";
    homepage = "https://github.com/fox-it/acquire";
    changelog = "https://github.com/fox-it/acquire/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
