{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-benchmark
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.1.5";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "055gfvyax781f4zk4pl60y8yd90bnn4rkqh5i48pczaff0lwlfj1";
  };

  checkInputs = [
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [ "graphql" ];

  meta = with lib; {
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
