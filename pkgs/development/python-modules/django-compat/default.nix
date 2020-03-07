{ stdenv, buildPythonPackage, fetchFromGitHub, python,
  django, six
}:

buildPythonPackage rec {
  pname = "django-compat";
  version = "1.0.15";

  # the pypi packages don't include everything required for the tests
  src = fetchFromGitHub {
    owner = "arteria";
    repo = "django-compat";
    rev = "v${version}";
    sha256 = "1pr6v38ahrsvxlgmcx69s4b5q5082f44gzi4h3c32sccdc4pwqxp";
  };

  patches = [
    ./fix-tests.diff
  ];

  checkPhase = ''
    runHook preCheck

    # to convince the tests to run against the installed package, not the source directory, we extract the
    # tests directory from it then dispose of the actual source
    mv compat/tests .
    rm -r compat
    substituteInPlace runtests.py --replace compat.tests tests
    ${python.interpreter} runtests.py

    runHook postCheck
  '';

  propagatedBuildInputs = [ django six ];

  meta = with stdenv.lib; {
    description = "Forward and backwards compatibility layer for Django 1.4, 1.7, 1.8, 1.9, 1.10 and 1.11";
    homepage = https://github.com/arteria/django-compat;
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
