{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-benchmark
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.1.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mwwh55qd5bcpvgy6pyliwn8jkmj4yk4d2pqb6mdkgqhdic2081l";
  };

  checkInputs = [
    pytest-asyncio
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "graphql"
  ];

  meta = with lib; {
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
