{ lib
, buildPythonPackage
, fetchPypi
, frozendict
, simplejson
, six
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "899b7604f5a6a8a92109115d9250142cdf0b1dfdcb62cdb21d8fb5bf37780631";
  };

  propagatedBuildInputs = [
    frozendict
    simplejson
    six
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_frozen_dict"
  ];

  meta = with lib; {
    homepage = "https://github.com/matrix-org/python-canonicaljson";
    description = "Encodes objects and arrays as RFC 7159 JSON.";
    license = licenses.asl20;
  };
}
