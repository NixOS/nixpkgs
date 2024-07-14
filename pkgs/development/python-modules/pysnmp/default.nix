{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyasn1,
  pycryptodomex,
  pysmi,
}:

buildPythonPackage rec {
  pname = "pysnmp";
  version = "4.4.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DD2+8vlYysqWBx/lwZ3kPpwbBISrAqDPCLGQvO52i6k=";
  };

  patches = [ ./setup.py-Fix-the-setuptools-version-check.patch ];

  # NameError: name 'mibBuilder' is not defined
  doCheck = false;

  propagatedBuildInputs = [
    pyasn1
    pycryptodomex
    pysmi
  ];

  meta = with lib; {
    homepage = "http://snmplabs.com/pysnmp/index.html";
    description = "Pure-Python SNMPv1/v2c/v3 library";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      primeos
      koral
    ];
  };
}
