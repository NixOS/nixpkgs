{ lib, buildPythonPackage, fetchPypi
, translationstring, iso8601, enum34 }:

buildPythonPackage rec {
  pname = "colander";
  version = "1.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "259592a0d6a89cbe63c0c5771f9c0c2522387415af8d715f599583eac659f7d4";
  };

  propagatedBuildInputs = [ translationstring iso8601 enum34 ];

  meta = with lib; {
    description = "A simple schema-based serialization and deserialization library";
    homepage = "https://docs.pylonsproject.org/projects/colander/en/latest/";
    license = licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = with maintainers; [ domenkozar ];
  };
}
