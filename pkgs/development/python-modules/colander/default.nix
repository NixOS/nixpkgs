{ lib, buildPythonPackage, fetchPypi
, translationstring, iso8601, enum34 }:

buildPythonPackage rec {
  pname = "colander";
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54878d2ffd1afb020daca6cd5c6cfe6c0e44d0069fc825d57fe59aa6e4f6a499";
  };

  propagatedBuildInputs = [ translationstring iso8601 enum34 ];

  meta = with lib; {
    description = "A simple schema-based serialization and deserialization library";
    homepage = "https://docs.pylonsproject.org/projects/colander/en/latest/";
    license = licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = with maintainers; [ domenkozar ];
  };
}
