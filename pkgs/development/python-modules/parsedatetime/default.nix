{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, future
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "parsedatetime";
  version = "2.6";
  disabled = isPy27; # no longer compatible with icu package

  src = fetchPypi {
    inherit pname version;
    sha256 = "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455";
  };

  propagatedBuildInputs = [ future ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/Test*.py" ];

  disabledTests = [
    # https://github.com/bear/parsedatetime/issues/263
    "testDate3ConfusedHourAndYear"
    # https://github.com/bear/parsedatetime/issues/215
    "testFloat"
  ];

  pythonImportsCheck = [ "parsedatetime" ];

  meta = with lib; {
    description = "Parse human-readable date/time text";
    homepage = "https://github.com/bear/parsedatetime";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
