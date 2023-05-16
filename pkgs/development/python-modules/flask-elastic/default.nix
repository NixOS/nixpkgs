{ lib, buildPythonPackage, fetchPypi
, flask, elasticsearch }:

buildPythonPackage rec {
<<<<<<< HEAD
  pname = "flask-elastic";
  version = "0.2";

  src = fetchPypi {
    pname = "Flask-Elastic";
    inherit version;
    hash = "sha256-XwGm/FQbXSV2qbAlHyAbT4DLcQnIseDm1Qqdb5zjE0M=";
=======
  pname = "Flask-Elastic";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hqkwff6z78aspkf1cf815qwp02g3ch1y9dhm5v2ap8vakyac0az";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ flask elasticsearch ];
  doCheck = false; # no tests

  meta = with lib; {
    description = "Integrates official client for Elasticsearch into Flask";
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
    homepage = "https://github.com/marceltschoppch/flask-elastic";
  };
}
