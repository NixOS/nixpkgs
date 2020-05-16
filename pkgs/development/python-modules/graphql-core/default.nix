{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, lib

, pytest
, pytest-benchmark
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.1.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "058318j1c1g26bgm10sf89iqi6c0wvkwpk8v2fybs53zy062xlwx";
  };

  checkInputs = [
    pytest
    pytest-benchmark
  ];

  checkPhase = "pytest";

  meta = with lib; {
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
