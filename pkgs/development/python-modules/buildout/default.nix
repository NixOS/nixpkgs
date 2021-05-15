{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.13.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b978b2f9317b317ee4191f78fcc4f05b1ac41bdaaae47f0956f14c8285feef63";
  };

  meta = with lib; {
    homepage = "http://www.buildout.org";
    description = "A software build and configuration system";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
