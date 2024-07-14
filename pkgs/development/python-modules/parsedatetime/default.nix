{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  future,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "parsedatetime";
  version = "2.6";
  format = "setuptools";
  disabled = isPy27; # no longer compatible with icu package

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TLNo+7GKC3Ix9NdhGRZUUcjS41lRRV3+6XxiqHsE1FU=";
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
