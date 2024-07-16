{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  django,
  jinja2,
  python,
}:

buildPythonPackage rec {
  pname = "django-jinja";
  version = "2.11.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "niwinz";
    repo = "django-jinja";
    rev = "refs/tags/${version}";
    hash = "sha256-0gkv9xinHux8TRiNBLl/JgcimXU3CzysxzGR2jn7OZ4=";
  };

  propagatedBuildInputs = [
    django
    jinja2
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} testing/runtests.py

    runHook postCheck
  '';

  meta = {
    description = "Simple and nonobstructive jinja2 integration with Django";
    homepage = "https://github.com/niwinz/django-jinja";
    changelog = "https://github.com/niwinz/django-jinja/blob/${src.rev}/CHANGES.adoc";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
