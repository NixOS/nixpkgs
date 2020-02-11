{ stdenv, buildPythonPackage, fetchFromGitHub, six, django, fetchpatch }:
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

  patches = [
    (fetchpatch {
      name = "backport_django_2_2.patch";
      url = "https://github.com/django-compressor/django-appconf/commit/1526a842ee084b791aa66c931b3822091a442853.patch";
      sha256 = "1vl2s6vlf15089s8p4c3g4d5iqm8jva66bdw683r8440f80ixgmw";
    })
  ];

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
