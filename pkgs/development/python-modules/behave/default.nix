{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  pytestCheckHook,
  assertpy,
  chardet,
  freezegun,
  mock,
  path,
  pyhamcrest,
  pytest-html,
  colorama,
  cucumber-expressions,
  cucumber-tag-expressions,
  parse,
  parse-type,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "behave";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "behave";
    repo = "behave";
    tag = "v${version}";
    hash = "sha256-sHsnBeyl0UJ0f7WcTUc+FhUxATh84RPxVE3TqGYosrs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    assertpy
    chardet
    freezegun
    mock
    path
    pyhamcrest
    pytest-html
  ];

  pythonImportsCheck = [ "behave" ];

  dependencies = [
    colorama
    cucumber-expressions
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
    changelog = "https://github.com/behave/behave/blob/${src.tag}/CHANGES.rst";
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
