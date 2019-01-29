{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
    pname = "pyparsing";
    version = "2.3.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "f353aab21fd474459d97b709e527b5571314ee5f067441dc9f88e33eecd96592";
    };

    # Not everything necessary to run the tests is included in the distribution
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = http://pyparsing.wikispaces.com/;
      description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
      license = licenses.mit;
    };
}
