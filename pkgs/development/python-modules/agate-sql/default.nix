{ lib, stdenv, fetchPypi, buildPythonPackage, agate, sqlalchemy, crate }:

buildPythonPackage rec {
    pname = "agate-sql";
    version = "0.5.5";

    src = fetchPypi {
      inherit pname version;
      sha256 = "50a39754babef6cd0d1b1e75763324a49593394fe46ab1ea9546791b5e6b69a7";
    };

    propagatedBuildInputs = [ agate sqlalchemy crate ];

    meta = with lib; {
      description = "Adds SQL read/write support to agate.";
      homepage    = "https://github.com/wireservice/agate-sql";
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
