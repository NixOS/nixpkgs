{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2019.9.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l0yw94ypd117bl7f0fx8sqw9wsnrpcsn92vr7nkxy54zq665wz4";
  };

  meta = {
    homepage = http://certifi.io/;
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}
