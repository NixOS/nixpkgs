{
  lib,
  fetchPypi,
  fetchpatch,
  buildPythonPackage,
  dos2unix,
  pyasn1,
}:

buildPythonPackage rec {
  pname = "ldap3";
  version = "2.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f";
  };

  prePatch = ''
    # patch fails to apply because of line endings
    dos2unix ldap3/utils/asn1.py
  '';

  patches = [
    # fix pyasn1 0.5.0 compability
    # https://github.com/cannatag/ldap3/pull/983
    (fetchpatch {
      url = "https://github.com/cannatag/ldap3/commit/ca689f4893b944806f90e9d3be2a746ee3c502e4.patch";
      hash = "sha256-A8qI0t1OV3bkKaSdhVWHFBC9MoSkWynqxpgznV+5gh8=";
    })
  ];

  nativeBuildInputs = [ dos2unix ];

  propagatedBuildInputs = [ pyasn1 ];

  doCheck = false; # requires network

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/ldap3";
    description = "Strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
