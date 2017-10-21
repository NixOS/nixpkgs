{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2017.7.27.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5";
  };

  meta = {
    homepage = http://certifi.io/;
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}