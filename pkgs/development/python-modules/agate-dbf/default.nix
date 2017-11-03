{ stdenv, fetchPypi, buildPythonPackage, agate, dbf, dbfread }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "agate-dbf";
    version = "0.2.0";

    propagatedBuildInputs = [ agate dbf dbfread ];

    src = fetchPypi {
      inherit pname version;
      sha256 = "0pkk6m873xpqj77ja6ylmg8v41abpn4bvsqw6mh2hjyd0snw2rh6";
    };

    meta = with stdenv.lib; {
      description = "Adds read support for dbf files to agate";
      homepage    = https://github.com/wireservice/agate-dbf;
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
