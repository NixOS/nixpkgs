{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  conda-package-streaming,
  filelock,
  jinja2,
  ruamel-yaml,
  zstandard,
  click,
  msgpack,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "conda-build";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda-index";
    tag = version;
    hash = "sha256-ATM6cQ6JpHAAOxUwikuRtUF5yfPe4xn1leGgSNX4LN8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];
  dependencies = [
    conda-package-streaming
    filelock
    jinja2
    ruamel-yaml
    zstandard
    click
    msgpack
  ];
  # TODO: Do pytest in passthru.tests (circular dependency w/ conda-build)
  # nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "conda_index" ];

  meta = {
    description = "Create channels from collections of packages";
    homepage = "https://conda.github.io/conda-index/";
    changelog = "https://conda.github.io/conda-index/changelog.html";
    maintainers = with lib.maintainers; [ pandapip1 ];
    license = lib.licenses.bsd3;
  };
}
