{
  lib,
  buildPythonPackage,
  chardet,
  fetchPypi,
  hatchling,
  jinja2,
  pluggy,
  pycodestyle,
  pyflakes,
  pygments,
  pylint,
  pytest-datadir,
  pytest-mock,
  pytestCheckHook,
  tomli,
}:

buildPythonPackage rec {
  pname = "diff-cover";
  version = "10.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "diff_cover";
    inherit version;
    hash = "sha256-jRGU37U39wSArJfJxF3UByHPTDJsmQP76ZfbZ6TbYZU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    chardet
    jinja2
    pluggy
    pygments
  ];

  optional-dependencies = {
    toml = [ tomli ];
  };

  nativeCheckInputs = [
    pycodestyle
    pyflakes
    pylint
    pytest-datadir
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "diff_cover" ];

  meta = {
    description = "Automatically find diff lines that need test coverage";
    homepage = "https://github.com/Bachmann1234/diff-cover";
    changelog = "https://github.com/Bachmann1234/diff_cover/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "diff-cover";
  };
}
