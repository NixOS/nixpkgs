{ lib, buildPythonPackage, fetchPypi
, translationstring, iso8601 }:

buildPythonPackage rec {
  pname = "colander";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e20e9acf190e5711cf96aa65a5405dac04b6e841028fc361d953a9923dbc4e72";
  };

  propagatedBuildInputs = [ translationstring iso8601 ];

  meta = with lib; {
    description = "A simple schema-based serialization and deserialization library";
    homepage = https://docs.pylonsproject.org/projects/colander/en/latest/;
    license = licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = with maintainers; [ garbas domenkozar ];
  };
}
