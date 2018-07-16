{ stdenv, fetchPypi, buildPythonPackage, agate, openpyxl, xlrd }:

buildPythonPackage rec {
    pname = "agate-excel";
    version = "0.2.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "8923f71ee2b5b7b21e52fb314a769b28fb902f647534f5cbbb41991d8710f4c7";
    };

    propagatedBuildInputs = [ agate openpyxl xlrd ];

    meta = with stdenv.lib; {
      description = "Adds read support for excel files to agate";
      homepage    = "https://github.com/wireservice/agate-excel";
      license     = licenses.mit;
      maintainers = with maintainers; [ vrthra ];
    };

}
