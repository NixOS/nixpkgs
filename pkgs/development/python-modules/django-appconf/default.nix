{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  django,
  six,
  python,
}:

buildPythonPackage rec {
  pname = "django-appconf";
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "django-compressor";
    repo = "django-appconf";
    rev = "v${version}";
    hash = "sha256-nS4Hwp/NYg1XGvZO1tiE9mzJA7WFifyvgAjyp3YpqS4=";
  };

  propagatedBuildInputs = [ django ];

  preCheck = ''
    # prove we're running tests against installed package, not build dir
    rm -r appconf
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test --settings=tests.test_settings
    runHook postCheck
  '';

  meta = with lib; {
    description = "Helper class for handling configuration defaults of packaged apps gracefully";
    homepage = "https://django-appconf.readthedocs.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };
}
