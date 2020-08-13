{ lib, buildPythonPackage, fetchPypi
, requests, cryptography, pybrowserid, hawkauthlib, six
, grequests, mock, responses, pytest }:

buildPythonPackage rec {
  pname = "PyFxA";
  version = "0.7.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c85cd08cf05f7138dee1cf2a8a1d68fd428b7b5ad488917c70a2a763d651cdb";
  };

  postPatch = ''
    # Requires network access
    rm fxa/tests/test_core.py
  '';

  propagatedBuildInputs = [
    requests cryptography pybrowserid hawkauthlib six
  ];

  checkInputs = [
    grequests mock responses pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Firefox Accounts client library for Python";
    homepage = "https://github.com/mozilla/PyFxA";
    license = licenses.mpl20;
  };
}
