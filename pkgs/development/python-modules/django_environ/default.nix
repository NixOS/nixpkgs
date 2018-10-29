{ stdenv
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-environ";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ylw16v5z46ckn8ynbx2zjam6nvipl0xxcr6icrf6driv02q8bzf";
  };

  # The testsuite fails to modify the base environment
  doCheck = false;
  propagatedBuildInputs = [ django six ];

  meta = with stdenv.lib; {
    description = "Utilize environment variables to configure your Django application";
    homepage = https://github.com/joke2k/django-environ/;
    license = licenses.mit;
  };

}
