{ lib, buildPythonPackage, fetchPypi
, translationstring, iso8601, enum34 }:

buildPythonPackage rec {
  pname = "colander";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QZzWgXjS7m7kyuXVyxgwclY0sKKECRcVbonrJZIjfvM=";
  };

  propagatedBuildInputs = [ translationstring iso8601 enum34 ];

  meta = with lib; {
    description = "A simple schema-based serialization and deserialization library";
    homepage = "https://docs.pylonsproject.org/projects/colander/en/latest/";
    license = licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = with maintainers; [ domenkozar ];
  };
}
