{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  lz4,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  zstandard,
}:

buildPythonPackage rec {
  pname = "mcap";
  version = "1.3.1"; # Replace with the specific version you need
  pyproject = true;

  src = fetchFromGitHub {
    owner = "foxglove";
    repo = "mcap";
    rev = "releases/python/mcap/v${version}";
    hash = "sha256-3H36Q9JDxC44UnIdgtCMAkeT3+tEOloxAI7fext2YXk=";
    fetchLFS = true;
  };

  sourceRoot = "source/python/mcap";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    lz4
    zstandard
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = true;
  pythonImportsCheck = [ "mcap" ];

  meta = {
    description = "MCAP Python library";
    downloadPage = "https://github.com/foxglove/mcap/tree/main/python/mcap";
    homepage = "https://mcap.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
