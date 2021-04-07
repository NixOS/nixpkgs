{ buildPythonPackage
, fetchFromGitHub
, lib
, pythonOlder

, coveralls
, promise
, pytestCheckHook
, pytest-benchmark
, pytest-mock
, rx
, six
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.1.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qy1i6vffwad74ymdsh1qjf5b6ph4z0vyxzkkc6yppwczhzmi1ps";
  };

  checkInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
