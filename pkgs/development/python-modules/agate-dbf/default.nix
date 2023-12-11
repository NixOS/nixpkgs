{ lib, fetchPypi, buildPythonPackage, agate, dbf, dbfread }:

buildPythonPackage rec {
    pname = "agate-dbf";
    version = "0.2.2";
    format = "setuptools";

    propagatedBuildInputs = [ agate dbf dbfread ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "589682b78c5c03f2dc8511e6e3edb659fb7336cd118e248896bb0b44c2f1917b";
    };

    meta = with lib; {
      description = "Adds read support for dbf files to agate";
      homepage    = "https://github.com/wireservice/agate-dbf";
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
