{ lib, buildPythonPackage, fetchPypi, isPy27, unittest2, six }:

buildPythonPackage rec {
  pname = "logilab-common";
  version = "1.6.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h0b2vg2xpfbnynrkg2yki4zjpscm6wgm6nhaahb088v98zxqbrk";
  };

  propagatedBuildInputs = [ unittest2 six ];

  # package supports 3.x but tests require egenix-mx-base which is python 2.x only
  # and is not currently in nixos
  doCheck = false;

  meta = with lib; {
    description = "Python packages and modules used by Logilab ";
    homepage = "https://www.logilab.org/project/logilab-common";
    license = licenses.lgpl21;
  };
}
