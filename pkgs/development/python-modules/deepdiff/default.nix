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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "deepdiff";
  version = "5.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "seperman";
    repo = "deepdiff";
    rev = "v${version}";
    hash = "sha256-7eagu6lef5bc/4KU3y067LFOGtH6whda1ocBuRHS/kI=";
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
    maintainers = with maintainers; [ mic92 ];
  };
}
