{ lib, fetchFromGitHub, buildPythonPackage, pythonOlder, nose }:

buildPythonPackage rec {
  pname = "rx";
  version = "3.2.0";
  disabled = pythonOlder "3.6";

  # There are no tests on the pypi source
  src = fetchFromGitHub {
    owner = "ReactiveX";
    repo = "rxpy";
    rev = "v${version}";
    sha256 = "159ln0c721rrdz0mqyl3zvv6qsry7ql7ddlpwpnxs9q15ik15mnj";
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
