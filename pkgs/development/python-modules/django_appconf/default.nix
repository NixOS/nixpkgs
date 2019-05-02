{ stdenv, buildPythonPackage, fetchPypi, six }:
buildPythonPackage rec {
  pname = "django-appconf";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35f13ca4d567f132b960e2cd4c832c2d03cb6543452d34e29b7ba10371ba80e3";
  };

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "A helper class for handling configuration defaults of packaged apps gracefully";
    homepage = https://django-appconf.readthedocs.org/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };
}
