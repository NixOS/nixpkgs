{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2019.6.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "945e3ba63a0b9f577b1395204e13c3a231f9bc0223888be653286534e5873695";
  };

  meta = {
    homepage = http://certifi.io/;
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}
