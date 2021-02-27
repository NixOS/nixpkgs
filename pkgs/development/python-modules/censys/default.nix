{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, requests
, pytestcov
, requests-mock
, parameterized
}:

buildPythonPackage rec {
  pname = "censys";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    rev = version;
    sha256 = "06jwk0ps80fjzbsy24qn5bsggfpgn4ccjzjz65cdh0ap1mfvh5jf";
  };

  propagatedBuildInputs = [
    backoff
    requests
  ];

  checkInputs = [
    pytestcov
    pytestCheckHook
    requests-mock
    parameterized
  ];

  # The tests want to write a configuration file
  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME
    '';
  # All other tests require an API key
  pytestFlagsArray = [ "tests/test_config.py" ];
  pythonImportsCheck = [ "censys" ];

  meta = with lib; {
    description = "Python API wrapper for the Censys Search Engine (censys.io)";
    homepage = "https://github.com/censys/censys-python";
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.fab ];
  };
}
