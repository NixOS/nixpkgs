{ lib, stdenv, fetchFromGitHub
, buildPythonApplication, python
, pytestCheckHook, mock, pathpy, pyhamcrest, pytest-html
, glibcLocales
, colorama, cucumber-tag-expressions, parse, parse-type, six
}:

buildPythonApplication rec {
  pname = "behave";
  version = "1.2.7.dev1";

  src = fetchFromGitHub {
    owner = "behave";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ssgixmqlg8sxsyalr83a1970njc2wg3zl8idsmxnsljwacv7qwv";
  };

  checkInputs = [ pytestCheckHook mock pathpy pyhamcrest pytest-html ];

  # upstream tests are failing, so instead we only check if we can import it
  doCheck = false;

  pythonImportsCheck = [ "behave" ];

  buildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ colorama cucumber-tag-expressions parse parse-type six ];

  postPatch = ''
    patchShebangs bin
  '';

  # timing-based test flaky on Darwin
  # https://github.com/NixOS/nixpkgs/pull/97737#issuecomment-691489824
  disabledTests = lib.optionals stdenv.isDarwin [ "test_step_decorator_async_run_until_complete" ];

  postCheck = ''
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"

    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' features/
    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' tools/test-features/
    ${python.interpreter} bin/behave -f progress3 --stop --tags='~@xfail' issue.features/
  '';

  meta = with lib; {
    homepage = "https://github.com/behave/behave";
    description = "behaviour-driven development, Python style";
    license = licenses.bsd2;
    maintainers = with maintainers; [ alunduil maxxk ];
  };
}
