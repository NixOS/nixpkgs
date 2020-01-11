{ stdenv, buildPythonPackage, fetchFromGitHub, six, django }:
buildPythonPackage rec {
  pname = "django-appconf";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "django-compressor";
    repo = "django-appconf";
    rev = version;
    sha256 = "06hwbz7362y0la9np3df25mms235fcqgpd2vn0mnf8dri9spzy1h";
  };

  propagatedBuildInputs = [ six django ];

  checkPhase = ''
    # prove we're running tests against installed package, not build dir
    rm -r appconf
    python -m django test --settings="tests.test_settings"
  '';

  meta = with stdenv.lib; {
    description = "A helper class for handling configuration defaults of packaged apps gracefully";
    homepage = https://django-appconf.readthedocs.org/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };
}
