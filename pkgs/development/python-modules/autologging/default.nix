{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Autologging";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16v2k16m433fxlvl7f0081n67rpxhs2hyn1ivkx1xs5qjxpv5n3k";
    extension = "zip";
  };

  meta = with stdenv.lib; {
    homepage = http://ninthtest.info/python-autologging/;
    description = "Easier logging and tracing for Python classes";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
