{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, parameterized
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, responses
, rich
, types-requests
}:

buildPythonPackage rec {
  pname = "censys";
  version = "2.0.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    rev = "v${version}";
    sha256 = "0ga5f6xv6rylfvalnl3cflr0w30r771gb05n5cjhxisb8an0qcb6";
  };

  propagatedBuildInputs = [
    backoff
    requests
    rich
    types-requests
  ];

  checkInputs = [
    parameterized
    pytestCheckHook
    requests-mock
    responses
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "rich==10.3.0" "rich" \
      --replace "types-requests==0.1.11" "types-requests"
    substituteInPlace pytest.ini --replace \
      " --cov -rs -p no:warnings" ""
  '';

  # The tests want to write a configuration file
  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME
  '';

  pythonImportsCheck = [ "censys" ];

  meta = with lib; {
    description = "Python API wrapper for the Censys Search Engine (censys.io)";
    homepage = "https://github.com/censys/censys-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
