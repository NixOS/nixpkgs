{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # fix tests: https://github.com/behave/behave/pull/1214
    (fetchpatch2 {
      url = "https://github.com/behave/behave/pull/1214/commits/98b63a2524eff50ce1dc7360a46462a6f673c5ea.patch?full_index=1";
      hash = "sha256-MwODEm6vhg/H8ksp5XBBP5Uhu2dhB5B1T6Owkxpy3v0=";
    })
  ];

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
    description = "Behaviour-driven development, Python style";
    mainProgram = "behave";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      alunduil
      maxxk
    ];
  };
}
