{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "logutils";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "173w55fg3hp5dhx7xvssmgqkcv5fjlaik11w5dah2fxygkjvhhj0";
  };

  meta = with stdenv.lib; {
    description = "Logging utilities";
    homepage = http://code.google.com/p/logutils/;
    license = licenses.bsd0;
  };

}
