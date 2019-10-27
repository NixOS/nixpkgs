{ stdenv, fetchPypi, buildPythonPackage, agate, sqlalchemy }:

buildPythonPackage rec {
    pname = "agate-sql";
    version = "0.5.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "9277490ba8b8e7c747a9ae3671f52fe486784b48d4a14e78ca197fb0e36f281b";
    };

    propagatedBuildInputs = [ agate sqlalchemy ];

    meta = with stdenv.lib; {
      description = "Adds SQL read/write support to agate.";
      homepage    = https://github.com/wireservice/agate-sql;
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
