{ lib, buildPythonPackage, fetchPypi
, translationstring, iso8601, enum34 }:

buildPythonPackage rec {
  pname = "colander";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d758163a22d22c39b9eaae049749a5cd503f341231a02ed95af480b1145e81f2";
  };

  propagatedBuildInputs = [ translationstring iso8601 enum34 ];

  meta = with lib; {
    description = "A simple schema-based serialization and deserialization library";
    homepage = https://docs.pylonsproject.org/projects/colander/en/latest/;
    license = licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = with maintainers; [ domenkozar ];
  };
}
