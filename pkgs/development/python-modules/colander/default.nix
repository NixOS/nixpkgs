{ lib, buildPythonPackage, fetchPypi
, translationstring, iso8601, enum34 }:

buildPythonPackage rec {
  pname = "colander";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18ah4cwwxnpm6qxi6x9ipy51dal4spd343h44s5wd01cnhgrwsyq";
  };

  propagatedBuildInputs = [ translationstring iso8601 enum34 ];

  meta = with lib; {
    description = "A simple schema-based serialization and deserialization library";
    homepage = https://docs.pylonsproject.org/projects/colander/en/latest/;
    license = licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = with maintainers; [ garbas domenkozar ];
  };
}
