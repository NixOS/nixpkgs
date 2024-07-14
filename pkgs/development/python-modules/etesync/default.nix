{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  appdirs,
  asn1crypto,
  cffi,
  cryptography,
  furl,
  idna,
  orderedmultidict,
  packaging,
  peewee,
  py,
  pyasn1,
  pycparser,
  pyparsing,
  pyscrypt,
  python-dateutil,
  pytz,
  requests,
  six,
  vobject,
  pytest,
}:

buildPythonPackage rec {
  pname = "etesync";
  version = "0.12.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8g9+mSLueJxLcTeWduv+ZWtnWRP+Uk8u5yLhue9OUZc=";
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

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest tests/test_collections.py
    pytest tests/test_crypto.py
  '';

  meta = with lib; {
    homepage = "https://www.etesync.com/";
    description = "Python API to interact with an EteSync server";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ valodim ];
  };
}
