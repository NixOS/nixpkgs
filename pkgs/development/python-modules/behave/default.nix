{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  pythonOlder,
  pytestCheckHook,
  assertpy,
  mock,
  path,
  pyhamcrest,
  pytest-html,
  colorama,
  cucumber-tag-expressions,
  parse,
  parse-type,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "behave";
  version = "1.2.7.dev5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "behave";
    repo = "behave";
    rev = "v${version}";
    hash = "sha256-G1o0a57MRczwjGLl/tEYC+yx3nxpk6+E58RvR9kVJpA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    assertpy
    mock
    path
    pyhamcrest
    pytest-html
  ];

  doCheck = pythonOlder "3.12";

  pythonImportsCheck = [ "behave" ];

  dependencies = [
    colorama
    cucumber-tag-expressions
    parse
    parse-type
    six
  ];

  postPatch = ''
    patchShebangs bin
  '';

  # timing-based test flaky on Darwin
  # https://github.com/NixOS/nixpkgs/pull/97737#issuecomment-691489824
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_step_decorator_async_run_until_complete"
  ];

  postCheck = ''
    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' features/
    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' tools/test-features/
    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' issue.features/
  '';

  meta = with lib; {
    changelog = "https://github.com/behave/behave/blob/${src.rev}/CHANGES.rst";
    homepage = "https://github.com/behave/behave";
    description = "behaviour-driven development, Python style";
    mainProgram = "behave";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      alunduil
      maxxk
    ];
  };
}
