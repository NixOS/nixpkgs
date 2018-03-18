{ lib, buildPythonPackage, fetchPypi
, translationstring, iso8601 }:

buildPythonPackage rec {
  pname = "colander";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7389413266b9e680c9529c16d56284edf87e0d5de557948e75f41d65683c23b3";
  };

  propagatedBuildInputs = [ translationstring iso8601 ];

  meta = with lib; {
    description = "A simple schema-based serialization and deserialization library";
    homepage = https://docs.pylonsproject.org/projects/colander/en/latest/;
    license = licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = with maintainers; [ garbas domenkozar ];
  };
}
