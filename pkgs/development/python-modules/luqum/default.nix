{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
# dependencies
, ply
# test dependencies
, elasticsearch-dsl
}:
let
  pname = "luqum";
  version = "0.13.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jurismarches";
    repo = pname;
    rev = version;
    hash = "sha256-lcJCLl0crCl3Y5UlWBMZJR2UtVP96gaJNRxwY9Xn7TM=";
  };

  propagatedBuildInputs = [
    ply
  ];

  nativeCheckInputs = [
    elasticsearch-dsl
  ];

  meta = with lib; {
    description = "A lucene query parser generating ElasticSearch queries and more !";
    homepage = "https://github.com/jurismarches/luqum";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
