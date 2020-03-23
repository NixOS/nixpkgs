{ lib, buildPythonPackage, fetchPypi, isPy27,
  appdirs, asn1crypto, cffi, cryptography, furl, idna, orderedmultidict,
  packaging, peewee, py, pyasn1, pycparser, pyparsing, pyscrypt,
  python-dateutil, pytz, requests, six, vobject,
  pytest
}:

buildPythonPackage rec {
  pname = "etesync";
  version = "0.10.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "09sdqviv9jyd013gxjjcw6vd4si860304haylvw4dp9kljsd94qa";
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
