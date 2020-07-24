{ lib, buildPythonPackage, fetchPypi, isPy27,
  appdirs, asn1crypto, cffi, cryptography, furl, idna, orderedmultidict,
  packaging, peewee, py, pyasn1, pycparser, pyparsing, pyscrypt,
  python-dateutil, pytz, requests, six, vobject,
  pytest
}:

buildPythonPackage rec {
  pname = "etesync";
  version = "0.11.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yads0s84z41hf003qk5i8222fi7096whzwfp48kf369gchp39kc";
  };

  propagatedBuildInputs = [
    appdirs
    asn1crypto
    cffi
    cryptography
    furl
    idna
    orderedmultidict
    packaging
    peewee
    py
    pyasn1
    pycparser
    pyparsing
    pyscrypt
    python-dateutil
    pytz
    requests
    six
    vobject
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest tests/test_collections.py
    pytest tests/test_crypto.py
  '';

  meta = with lib; {
    homepage = "https://www.etesync.com/";
    description = "A python API to interact with an EteSync server.";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ valodim ];
  };
}
