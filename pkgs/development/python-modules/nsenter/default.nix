{ lib, buildPythonPackage, fetchPypi, contextlib2, flake8, pathlib, pythonOlder, pythonAtLeast }:

buildPythonPackage rec {
  pname = "nsenter";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jr5592pshzn0ck75xb4f8dmcya8vb7x8byp9j7991fy0g5ihsl7";
  };

  propagatedBuildInputs = [
    contextlib2
    flake8
  ] ++ lib.optional (pythonOlder "3.4") [
    pathlib
  ];

  prePatch = lib.optionalString (pythonAtLeast "3.4") ''
    sed '/^pathlib$/d' -i requirements.txt # included in std since python 3.4
  '' + ''
    sed '/^argparse$/d' -i requirements.txt # included in std with python 2 and 3 for some time
  '';

  # there are none
  doCheck = false;

  meta = with lib; {
    description = "Enter kernel namespaces from Python";
    homepage = "https://github.com/zalando/python-nsenter";
    license = licenses.asl20;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
