{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2017.1.23";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1klrzl3hgvcf2mjk00g0k3kk1p2z27vzwnxivwar4vhjmjvpz1w1";
  };

  meta = {
    homepage = http://certifi.io/;
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}