{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dill,
  pandas,
  psutil,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pandarallel";
  version = "1.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nalepae";
    repo = "pandarallel";
    tag = "v${version}";
    hash = "sha256-F9xAF5L52hgAreKVSSYQitcgyGVkllA3UJGTy2mnXGQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dill
    pandas
    psutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "pandarallel"
  ];

  meta = {
    description = "Tool to parallelize Pandas operations across CPUs";
    homepage = "https://nalepae.github.io/pandarallel";
    changelog = "https://github.com/nalepae/pandarallel/releases/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
