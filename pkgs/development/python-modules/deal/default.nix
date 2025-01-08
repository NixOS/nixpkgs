{
  lib,
  astroid,
  buildPythonPackage,
  deal-solver,
  docstring-parser,
  fetchFromGitHub,
  flit-core,
  hypothesis,
  marshmallow,
  pygments,
  pytestCheckHook,
  pythonOlder,
  sphinx,
  typeguard,
  urllib3,
  vaa,
}:

buildPythonPackage rec {
  pname = "deal";
  version = "4.24.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "life4";
    repo = "deal";
    rev = "refs/tags/${version}";
    hash = "sha256-4orpoYfPGSvquhg9w63uUe8QbBa2RUpxaEJ9uy28+fU=";
  };

  postPatch = ''
    # don't do coverage
    substituteInPlace pyproject.toml \
      --replace-fail '"--cov-fail-under=100",' "" \
      --replace-fail '"--cov=deal",' "" \
      --replace-fail '"--cov-report=html",' "" \
      --replace-fail '"--cov-report=term-missing:skip-covered",' ""
  '';

  build-system = [ flit-core ];

  dependencies = [
    astroid
    deal-solver
    pygments
    typeguard
  ];

  nativeCheckInputs = [
    docstring-parser
    hypothesis
    marshmallow
    pytestCheckHook
    sphinx
    urllib3
    vaa
  ];

  disabledTests = [
    # Tests need internet access
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
    "test_source_get_lambda_multiline_splitted_dec"
  ];

  disabledTestPaths = [
    # Test needs internet access
    "tests/test_runtime/test_offline.py"
    # depends on typeguard <4.0.0 for tests, but >=4.0.0 seems fine for runtime
    # https://github.com/life4/deal/blob/9be70fa1c5a0635880619b2cea83a9f6631eb236/pyproject.toml#L40
    "tests/test_testing.py"
  ];

  pythonImportsCheck = [ "deal" ];

  meta = with lib; {
    description = "Library for design by contract (DbC) and checking values, exceptions, and side-effects";
    longDescription = ''
      In a nutshell, deal empowers you to write bug-free code.
      By adding a few decorators to your code, you get for free tests, static analysis, formal verification,
      and much more.
    '';
    homepage = "https://github.com/life4/deal";
    changelog = "https://github.com/life4/deal/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
