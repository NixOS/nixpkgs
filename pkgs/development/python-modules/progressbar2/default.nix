{
  lib,
  buildPythonPackage,
  dill,
  fetchPypi,
  freezegun,
  markupsafe,
  pytest-freezegun,
  pytestCheckHook,
  python-utils,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "4.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9BIkObANykFCT3h+pRSEeGhdJldCB4wcfD7eMfBr0AE=";
  };

  postPatch = ''
    sed -i "/-cov/d" pytest.ini

    # replace unwrapped interpreter call with wrapped entrypoint
    substituteInPlace tests/test_progressbar_command.py \
      --replace-fail "sys.executable, '-m', 'progressbar'" "'progressbar'"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ python-utils ];

  nativeCheckInputs = [
    dill
    markupsafe
    freezegun
    pytest-freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "progressbar" ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  disabledTests = [
    # overhead isn't always low on build infra
    "test_iterator_overhead_is_low"
  ];

  disabledTestPaths = [
    # Doesn't work in the sandbox
    "tests/test_readme_demos.py"
  ];

  meta = {
    description = "Text progressbar library";
    homepage = "https://progressbar-2.readthedocs.io/";
    changelog = "https://github.com/wolph/python-progressbar/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
