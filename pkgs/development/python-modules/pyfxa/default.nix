{ lib, buildPythonPackage, fetchPypi
, requests, cryptography, pybrowserid, hawkauthlib, six
, grequests, mock, responses, unittest2 }:

buildPythonPackage rec {
  pname = "PyFxA";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d511b6f43a9445587c609a138636d378de76661561116e1f4259fcec9d09b42b";
  };

  postPatch = ''
    # Requires network access
    rm fxa/tests/test_core.py
  '';

  propagatedBuildInputs = [
    requests cryptography pybrowserid hawkauthlib six
  ];

  checkInputs = [
    grequests mock responses unittest2
  ];

  meta = with lib; {
    description = "Firefox Accounts client library for Python";
    homepage = https://github.com/mozilla/PyFxA;
    license = licenses.mpl20;
  };
}
