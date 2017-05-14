{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hypothesis
, pytestcache
, pytestcov
, pytestflakes
, pytestpep8
, pytest
, mock
, pathlib ? null
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "natsort";
  version = "5.0.1";

  buildInputs = [
    hypothesis
    pytestcache
    pytestcov
    pytestflakes
    pytestpep8
    pytest
    mock
  ]
  # pathlib was made part of standard library in 3.5:
  ++ (lib.optionals (pythonOlder "3.4") [ pathlib ]);

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ad6b4d1153451e345967989bd3ca30abf33f615b116eeadfcc51a456e6974a9";
  };

  meta = {
    description = "Natural sorting for python";
    homepage = https://github.com/SethMMorton/natsort;
    license = lib.licenses.mit;
    broken = true;
  };
}
