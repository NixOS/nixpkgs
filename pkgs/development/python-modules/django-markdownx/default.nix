{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  markdown,
  pillow,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-markdownx";
  version = "4.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neutronX";
    repo = "django-markdownx";
    tag = "v${version}";
    hash = "sha256-dTNWTXHj5Tk77/XdIgfFGLir0JhlhwcWAIKDax8qM9M=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    django
    markdown
    pillow
  ];

  # tests only executable in vagrant
  doCheck = false;

  pythonImportsCheck = [ "markdownx" ];

  meta = {
    description = "Comprehensive Markdown plugin built for Django";
    homepage = "https://github.com/neutronX/django-markdownx/";
    changelog = "https://github.com/neutronX/django-markdownx/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
