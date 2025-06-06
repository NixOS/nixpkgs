{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pynose,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ipython-genutils";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ipython_genutils";
    inherit version;
    hash = "sha256-6y4RbnXs751NIo/cZq9UJpr6JqtEYwQuM3hbiHxii6g=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pynose
    pytestCheckHook
  ];

  preCheck = ''
    substituteInPlace ipython_genutils/tests/test_path.py \
      --replace-fail "setUp" "setup_method" \
      --replace-fail "tearDown" "teardown_method" \
      --replace-fail "assert_equals" "assert_equal" \
      --replace-fail "assert_not_equals" "assert_not_equal"
  '';

  pythonImportsCheck = [ "ipython_genutils" ];

  meta = {
    description = "Vestigial utilities from IPython";
    homepage = "https://ipython.org/";
    license = lib.licenses.bsd3;
  };
}
