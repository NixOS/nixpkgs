{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
    pname = "pyparsing";
    version = "2.4.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "4c830582a84fb022400b85429791bc551f1f4871c33f23e44f353119e92f969f";
    };

    # Not everything necessary to run the tests is included in the distribution
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = https://pyparsing.wikispaces.com/;
      description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
      license = licenses.mit;
    };
}
