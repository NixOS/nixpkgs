{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  python,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-formtools";
  version = "2.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R8s0VSxu/KCIhj1pMoTQT8NuqvNQ6yHhodk14N9SPJM=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ django ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m django test --settings=tests.settings

    runHook postCheck
  '';

  pythonImportsCheck = [ "formtools" ];

  meta = {
    description = "Set of high-level abstractions for Django forms";
    homepage = "https://github.com/jazzband/django-formtools";
    changelog = "https://github.com/jazzband/django-formtools/blob/master/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = [
    ];
  };
}
