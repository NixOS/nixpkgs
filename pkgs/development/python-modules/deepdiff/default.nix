{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, ordered-set
, clevercsv
, jsonpickle
, numpy
, pytestCheckHook
, pyyaml
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "5.5.0";
  format = "setuptools";

  # pypi source does not contain all fixtures required for tests
  src = fetchFromGitHub {
    owner = "seperman";
    repo = "deepdiff";
    rev = version;
    sha256 = "sha256-PQijGub0sAW0aBYI+Ir89SraXaWx7OcQ+txZSqodJ6w=";
  };

  propagatedBuildInputs = [
    click
    ordered-set
  ];

  pythonImportsCheck = [
    "deepdiff"
  ];

  checkInputs = [
    clevercsv
    jsonpickle
    numpy
    pytestCheckHook
    pyyaml
  ];

  meta = with lib; {
    description = "Deep Difference and Search of any Python object/data";
    homepage = "https://github.com/seperman/deepdiff";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
