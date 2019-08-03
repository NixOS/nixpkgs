{ stdenv, fetchPypi, buildPythonPackage, agate, dbf, dbfread }:

buildPythonPackage rec {
    pname = "agate-dbf";
    version = "0.2.1";

    propagatedBuildInputs = [ agate dbf dbfread ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "0brprva3vjypb5r9lk6zy10jazp681rxsqxzhz2lr869ir4krj80";
    };

    meta = with stdenv.lib; {
      description = "Adds read support for dbf files to agate";
      homepage    = https://github.com/wireservice/agate-dbf;
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
