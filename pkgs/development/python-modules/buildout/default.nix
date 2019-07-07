{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d14d07226963a517295dfad5879d2799e2e3b65b2c61c71b53cb80f5ab11484";
  };

  meta = with stdenv.lib; {
    homepage = http://www.buildout.org;
    description = "A software build and configuration system";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
