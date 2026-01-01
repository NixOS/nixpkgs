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
<<<<<<< HEAD
  version = "3.4.0";
=======
  version = "3.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gintas";
    repo = "django-picklefield";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-SvKJGOSsTZhAYJkGO+slL81EjcJtXmaFN7YWCGSX6Ac=";
=======
    hash = "sha256-/H6spsf2fmJdg5RphD8a4YADggr+5d+twuLoFMfyEac=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test --settings=tests.settings
    runHook postCheck
  '';

  pythonImportsCheck = [ "picklefield" ];

<<<<<<< HEAD
  meta = {
    description = "Pickled object field for Django";
    homepage = "https://github.com/gintas/django-picklefield";
    changelog = "https://github.com/gintas/django-picklefield/releases/tag/${src.tag}";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Pickled object field for Django";
    homepage = "https://github.com/gintas/django-picklefield";
    changelog = "https://github.com/gintas/django-picklefield/releases/tag/${src.tag}";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
