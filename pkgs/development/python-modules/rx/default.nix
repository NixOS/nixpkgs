{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, nose }:

buildPythonPackage rec {
  pname = "rx";
  version = "3.1.1";
  disabled = pythonOlder "3.6";

  # There are no tests on the pypi source
  src = fetchFromGitHub {
    owner = "ReactiveX";
    repo = "rxpy";
    rev = "v${version}";
    sha256 = "0p0cs67l40npkvwgn5sb18l1b6df1b9fg6rzlqkwk2aa0v3cpvhf";
  };

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
