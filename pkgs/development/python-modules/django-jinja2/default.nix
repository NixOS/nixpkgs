{ lib, buildPythonPackage, fetchPypi,
  django, jinja2, pytz, tox
 }:

buildPythonPackage rec {
  pname = "django-jinja";
  version = "2.9.1";

  meta = {
    description = "Simple and nonobstructive jinja2 integration with Django";
    homepage = "https://github.com/niwinz/django-jinja";
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c1fc68b0f4b1fb21b208a3e5dc19a3b11bab2812c06f827d5fdbd24001a1910";
  };

  buildInputs = [ django pytz tox ];
  propagatedBuildInputs = [ django jinja2 ];

  # python installed: The directory '/homeless-shelter/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.,appdirs==1.4.3,Django==1.11.1,django-jinja==2.2.2,Jinja2==2.9.6,MarkupSafe==1.0,packaging==16.8,pyparsing==2.2.0,pytz==2017.2,six==1.10.0
  doCheck = false;
  checkPhase = ''
    tox
  '';
}
