{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e180b62fd129a68cb3a9ec8eb0ef457e18921269a93e87ef2cc34519415332d";
  };

  meta = with stdenv.lib; {
    homepage = http://www.buildout.org;
    description = "A software build and configuration system";
    license = licenses.zpl21;
    maintainers = with maintainers; [ garbas ];
  };
}
