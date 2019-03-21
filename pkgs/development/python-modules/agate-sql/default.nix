{ stdenv, fetchPypi, buildPythonPackage, agate, sqlalchemy }:

buildPythonPackage rec {
    pname = "agate-sql";
    version = "0.5.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "877b7b85adb5f0325455bba8d50a1623fa32af33680b554feca7c756a15ad9b4";
    };

    propagatedBuildInputs = [ agate sqlalchemy ];

    meta = with stdenv.lib; {
      description = "Adds SQL read/write support to agate.";
      homepage    = https://github.com/wireservice/agate-sql;
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
