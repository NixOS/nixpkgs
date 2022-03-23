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
  version = "5.7.0";
  format = "setuptools";

  # pypi source does not contain all fixtures required for tests
  src = fetchFromGitHub {
    owner = "seperman";
    repo = "deepdiff";
    # 5.7.0 release not tagged https://github.com/seperman/deepdiff/issues/300
    rev = "f2ffdb83b2993f4f0bb7e854620f0acd0bf6339e";
    hash = "sha256-0UBx7sH2iMrLVl5FtHNTwoecLHi8GbInn75G3FSg4gk=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "ordered-set==4.0.2" "ordered-set"
    substituteInPlace tests/test_command.py \
      --replace '/tmp/' "$TMPDIR/"
  '';

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
