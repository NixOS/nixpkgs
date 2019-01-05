{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2018.10.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d58c986d22b038c8c0df30d639f23a3e6d172a05c3583e766f4c0b785c0986a";
  };

  meta = {
    homepage = http://certifi.io/;
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}