{ buildPythonPackage, freezegun, fetchFromGitHub, lib, pytestCheckHook
, pytest-mock, pytest-runner, six, tornado_4 }:

buildPythonPackage rec {
  pname = "lomond";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "wildfoundry";
    repo = "dataplicity-${pname}";
    rev = "b30dad3cc38d5ff210c5dd01f8c3c76aa6c616d1";
    sha256 = "0lydq0imala08wxdyg2iwhqa6gcdrn24ah14h91h2zcxjhjk4gv8";
  };

  nativeBuildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ six ];
  checkInputs = [ pytestCheckHook freezegun pytest-mock tornado_4 ];
  # Makes HTTP requests
  disabledTests = [ "test_proxy" "test_live" ];

  meta = with lib; {
    description = "Websocket Client Library";
    homepage = "https://github.com/wildfoundry/dataplicity-lomond";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
