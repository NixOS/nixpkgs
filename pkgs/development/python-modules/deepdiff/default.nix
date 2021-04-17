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
  version = "5.2.3";
  format = "setuptools";

  # pypi source does not contain all fixtures required for tests
  src = fetchFromGitHub {
    owner = "seperman";
    repo = "deepdiff";
    rev = version;
    sha256 = "0j3il23n3yfny6kzy2n67s0zsrqckck7x1ambqh29nzi0bqwslzk";
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
