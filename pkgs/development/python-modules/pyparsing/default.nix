{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
    pname = "pyparsing";
    version = "2.2.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "bc6c7146b91af3f567cf6daeaec360bc07d45ffec4cf5353f4d7a208ce7ca30a";
    };

    # Not everything necessary to run the tests is included in the distribution
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = http://pyparsing.wikispaces.com/;
      description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
      license = licenses.mit;
    };
}
