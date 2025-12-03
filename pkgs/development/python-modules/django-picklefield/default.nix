{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-picklefield";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gintas";
    repo = "django-picklefield";
    tag = "v${version}";
    hash = "sha256-SvKJGOSsTZhAYJkGO+slL81EjcJtXmaFN7YWCGSX6Ac=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test --settings=tests.settings
    runHook postCheck
  '';

  pythonImportsCheck = [ "picklefield" ];

  meta = with lib; {
    description = "Pickled object field for Django";
    homepage = "https://github.com/gintas/django-picklefield";
    changelog = "https://github.com/gintas/django-picklefield/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
