{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2018.8.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "376690d6f16d32f9d1fe8932551d80b23e9d393a8578c5633a2ed39a64861638";
  };

  meta = {
    homepage = http://certifi.io/;
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}