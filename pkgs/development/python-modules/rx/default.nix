{ lib, fetchFromGitHub, buildPythonPackage
, pythonOlder
, poetry-core
, nose
, typing-extensions
}:

buildPythonPackage rec {
  pname = "rx";
  version = "4.0.4";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  # There are no tests on the pypi source
  src = fetchFromGitHub {
    owner = "ReactiveX";
    repo = "rxpy";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-W1qYNbYV6Roz1GJtP/vpoPD6KigWaaQOWe1R5DZHlUw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  checkInputs = [ nose ];

  # Some tests are nondeterministic. (`grep sleep -r tests`)
  # test_timeout_schedule_action_cancel: https://hydra.nixos.org/build/74954646
  # test_new_thread_scheduler_timeout: https://hydra.nixos.org/build/74949851
  doCheck = false;

  meta = {
    homepage = "https://github.com/ReactiveX/RxPY";
    description = "Reactive Extensions for Python";
    maintainers = with lib.maintainers; [ thanegill ];
    license = lib.licenses.asl20;
  };
}
