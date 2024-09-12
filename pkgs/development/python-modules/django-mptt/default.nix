{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  django-js-asset,
  python,
}:

buildPythonPackage rec {
  pname = "django-mptt";
  version = "0.13.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "12y3chxhqxk2yxin055f0f45nabj0s8hil12hw0lwzlbax6k9ss6";
  };

  propagatedBuildInputs = [
    django
    django-js-asset
  ];

  pythonImportsCheck = [ "mptt" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/manage.py test
    runHook postCheck
  '';

  meta = with lib; {
    description = "Utilities for implementing a modified pre-order traversal tree in Django";
    homepage = "https://github.com/django-mptt/django-mptt";
    maintainers = with maintainers; [ hexa ];
    license = with licenses; [ mit ];
  };
}
