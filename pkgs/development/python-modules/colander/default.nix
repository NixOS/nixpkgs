{ lib, buildPythonPackage, fetchPypi
, translationstring, iso8601, enum34 }:

buildPythonPackage rec {
  pname = "colander";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wl1bqab307lbbcjx81i28s3yl6dlm4rf15fxawkjb6j48x1cn6p";
  };

  propagatedBuildInputs = [ translationstring iso8601 enum34 ];

  meta = with lib; {
    description = "A simple schema-based serialization and deserialization library";
    homepage = https://docs.pylonsproject.org/projects/colander/en/latest/;
    license = licenses.free; # http://repoze.org/LICENSE.txt
    maintainers = with maintainers; [ garbas domenkozar ];
  };
}
