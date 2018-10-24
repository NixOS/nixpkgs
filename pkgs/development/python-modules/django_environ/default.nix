{ stdenv
, buildPythonPackage
, fetchPypi
, django
, six
}:

buildPythonPackage rec {
  pname = "django-environ";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i32vsgk1xmwpi7i6f6v5hg653y9dl0fsz5qmv94skz6hwgm5kvh";
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
