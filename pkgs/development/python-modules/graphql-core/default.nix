{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-benchmark
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.1.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ip0yrqmnqncgpwvba18x020gkwr7csiw4zdy6mrdnvwf5qyam4x";
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
