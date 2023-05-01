{ lib
, buildPythonPackage
, pytest
, pythonOlder
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ndeflib";
  version = "0.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HVaChVi5sW8oIqQFGCQ0Y0e2at9TIOqGBwdItvJFSog=";
  };

  doTest = true;

  pythonImportsCheck = [
    "ndef"
  ];

  nativeCheckInputs = [ pytest ];

  # Two tests in AlternativeCarrierRecord fail, upstream hasn't been updated in a few years
  checkPhase = ''
    python3 -m pytest -k "not TestAlternativeCarrierRecord" tests/
  '';

  meta = with lib; {
    description = "NFC Data Exchange Format decoder and encoder";
    homepage = "https://github.com/nfcpy/ndeflib";
    license = licenses.isc;
    maintainers = with maintainers; [ RaghavSood ];
  };
}
