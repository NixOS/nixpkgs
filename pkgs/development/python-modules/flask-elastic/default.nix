{ stdenv, buildPythonPackage, fetchPypi
, flask, elasticsearch }:

buildPythonPackage rec {
  pname = "Flask-Elastic";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hqkwff6z78aspkf1cf815qwp02g3ch1y9dhm5v2ap8vakyac0az";
  };

  propagatedBuildInputs = [ flask elasticsearch ];
  doCheck = false; # no tests

  meta = with stdenv.lib; {
    description = "Integrates official client for Elasticsearch into Flask";
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
    homepage = "https://github.com/marceltschoppch/flask-elastic";
  };
}
