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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    rev = "v${version}";
    sha256 = "0vvd13g48i4alnqil98zc09zi5kv6l2s3kdfyg5syjxvq4lfd476";
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
