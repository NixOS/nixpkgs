{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flit-core
, astroid
, pytestCheckHook
, docstring-parser
, marshmallow
, sphinx
, hypothesis
, vaa
, deal-solver
, pygments
, typeguard
, urllib3
, flake8
}:

buildPythonPackage rec {
  pname = "deal";
  version = "4.24.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "life4";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-bdIoKOOC7qSer9Cp9A55HG960xunKXT2WiXp0UC6tsI=";
  };

  postPatch = ''
    # don't do coverage
    substituteInPlace pyproject.toml \
      --replace "\"--cov-fail-under=100\"," "" \
      --replace "\"--cov=deal\"," "" \
      --replace "\"--cov-report=html\"," "" \
      --replace "\"--cov-report=term-missing:skip-covered\"," ""
  '';

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    astroid
    deal-solver
    pygments
    typeguard
  ];

  nativeCheckInputs = [
    pytestCheckHook

    docstring-parser
    marshmallow
    sphinx
    hypothesis
    vaa
    urllib3
    flake8
  ];

  disabledTests = [
    # needs internet access
    "test_smoke_has"
    "test_pure_offline"
    "test_raises_doesnt_override_another_contract"
    "test_raises_doesnt_override_another_contract_async"
    "test_raises_generator"
    # AttributeError: module 'vaa' has no attribute 'Error'
    "test_source_vaa_scheme"
    "test_vaa_scheme_and_custom_exception"
    "test_scheme_string_validation_args_correct"
    "test_method_chain_decorator_with_scheme_is_fulfilled"
    "test_scheme_contract_is_satisfied_when_setting_arg"
    "test_scheme_contract_is_satisfied_within_chain"
    "test_scheme_errors_rewrite_message"
    # assert errors
    "test_doctest"
    "test_no_violations"
  ];

  disabledTestPaths = [
    # needs internet access
    "tests/test_runtime/test_offline.py"
    # needs update to latest version (4.24.3) to fix typeguard issues,
    # however upgrading it needs an astroid upgrade to 3.0+
    # this issue only affects tests and is safe to ignore for now, see:
    # https://github.com/life4/deal/commit/4821ebc341270af08e05f866d43f9458ba64ba8a
    "tests/test_testing.py"
  ];

  pythonImportsCheck = [ "deal" ];

  meta = with lib; {
    description = "Library for design by contract (DbC) and checking values, exceptions, and side-effects";
    longDescription = ''
      In a nutshell, deal empowers you to write bug-free code.
      By adding a few decorators to your code, you get for free tests, static analysis, formal verification, and much more
    '';
    homepage = "https://github.com/life4/deal";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
