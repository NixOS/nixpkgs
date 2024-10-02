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
  version = "3.16";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "acquire";
    rev = "refs/tags/${version}";
    hash = "sha256-wurnYHvzN5KfpikempYeztR9hkvGfRjR6M3tch6qFo4=";
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
    ] ++ dissect-target.optional-dependencies.full;
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.full;

  pythonImportsCheck = [ "acquire" ];

  meta = with lib; {
    description = "Tool to quickly gather forensic artifacts from disk images or a live system";
    homepage = "https://github.com/fox-it/acquire";
    changelog = "https://github.com/fox-it/acquire/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
