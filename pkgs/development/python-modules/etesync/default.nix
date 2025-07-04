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
    sha256 = "f20f7e9922ee789c4b71379676ebfe656b675913fe524f2ee722e1b9ef4e5197";
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
