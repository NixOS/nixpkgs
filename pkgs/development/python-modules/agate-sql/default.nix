{ stdenv, fetchPypi, buildPythonPackage, agate, sqlalchemy }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "agate-sql";
    version = "0.5.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0qlfwql6fnbs0r1rj7nxv4n5scad53b8dlh4qv6gyklvdk3wwn14";
    };

    propagatedBuildInputs = [ agate sqlalchemy ];

    meta = with stdenv.lib; {
      description = "Adds SQL read/write support to agate.";
      homepage    = https://github.com/wireservice/agate-sql;
      license     = with licenses; [ mit ];
      maintainers = with maintainers; [ vrthra ];
    };
}
