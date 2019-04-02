{ stdenv, fetchPypi, buildPythonPackage, agate, sqlalchemy }:

buildPythonPackage rec {
    pname = "agate-sql";
    version = "0.5.4";

    src = fetchPypi {
      inherit pname version;
      sha256 = "06r8dziv0zqrr9w4x8fl915pi1p45zsp2dmfm53wgrxqm05ljxwj";
    };

    propagatedBuildInputs = [ agate sqlalchemy ];

    meta = with stdenv.lib; {
      description = "Adds SQL read/write support to agate.";
      homepage    = https://github.com/wireservice/agate-sql;
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
