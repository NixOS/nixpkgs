{ stdenv
, fetchPypi
, buildPythonPackage
}:
buildPythonPackage rec {

  pname = "django-crispy-forms";
  version = "1.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5952bab971110d0b86c278132dae0aa095beee8f723e625c3d3fa28888f1675f";
  };

  # Checks are designed to be run by module's authors not users. Requires
  # extensive setup of django server.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://github.com/maraujop/django-crispy-forms";
    license = licenses.mit;
    description = "Best way to have Django DRY forms";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
