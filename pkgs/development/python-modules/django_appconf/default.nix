{ stdenv, buildPythonPackage, fetchPypi, six }:
buildPythonPackage rec {
  pname = "django-appconf";
  version = "1.0.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qdjdx35g66xjsc50v0c5h3kg6njs8df33mbjx6j4k1vd3m9lkba";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "A helper class for handling configuration defaults of packaged apps gracefully";
    homepage = http://django-appconf.readthedocs.org/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };
}
