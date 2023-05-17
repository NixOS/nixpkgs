{ lib
, buildPythonPackage
, fetchPypi
, six, pyyaml, mock
, pytestCheckHook
, enum34
, isPy3k
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9xs0hzG4x4wxAL/72VGnafvUOQiNH9uzhB7uAZr4Cs0=";
  };

  propagatedBuildInputs = lib.optionals (!isPy3k) [
    enum34
  ];

  nativeCheckInputs = [ six pyyaml mock pytestCheckHook ];

  preCheck = ''
    # pytest can't import one file even with PYTHONPATH set
    rm test/test_named_data.py
  '';

  meta = with lib; {
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";
    homepage = "https://github.com/txels/ddt";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
