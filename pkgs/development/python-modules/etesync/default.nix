{ lib, buildPythonPackage, fetchPypi, isPy27,
  appdirs, asn1crypto, cffi, cryptography, furl, idna, orderedmultidict,
  packaging, peewee, py, pyasn1, pycparser, pyparsing, pyscrypt,
  python-dateutil, pytz, requests, six, vobject,
  pytest
}:

buildPythonPackage rec {
  pname = "etesync";
  version = "0.9.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i6v7i4xmbpkc1pgpzq8gyl2kvg3a1kpdwp8q6l3l0vf9p5qm06w";
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
