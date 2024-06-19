{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pytest,
  pytest-django,
  python,
}:

buildPythonPackage rec {
  pname = "django-picklefield";
  version = "3.0.1";
  format = "setuptools";

  # The PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "gintas";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ni7bc86k0ra4pc8zv451pzlpkhs1nyil1sq9jdb4m2mib87b5fk";
  };

  propagatedBuildInputs = [ django ];

  # Tests are failing with Django 3.2
  # https://github.com/gintas/django-picklefield/issues/58
  doCheck = false;

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test --settings=tests.settings
    runHook postCheck
  '';

  meta = with lib; {
    description = "A pickled object field for Django";
    homepage = "https://github.com/gintas/django-picklefield";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
