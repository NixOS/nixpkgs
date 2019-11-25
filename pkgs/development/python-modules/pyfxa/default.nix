{ lib, buildPythonPackage, fetchPypi
, requests, cryptography, pybrowserid, hawkauthlib, six
, grequests, mock, responses, unittest2 }:

buildPythonPackage rec {
  pname = "PyFxA";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f47f4285629fa6c033c79adc3fb90926c0818a42cfddb04d32818547362f1627";
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
