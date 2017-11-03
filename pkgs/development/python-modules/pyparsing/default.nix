{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
    pname = "pyparsing";
    name = "${pname}-${version}";
    version = "2.2.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "016b9gh606aa44sq92jslm89bg874ia0yyiyb643fa6dgbsbqch8";
    };

    # Not everything necessary to run the tests is included in the distribution
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = http://pyparsing.wikispaces.com/;
      description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
      license = licenses.mit;
    };
}
