{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-webpack-loader";
  version = "3.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-webpack";
    repo = "django-webpack-loader";
    tag = finalAttrs.version;
    hash = "sha256-yWOzMjXauwOwlEjcZpjl/z6kE5bOYAdb+map1dHupWs=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  doCheck = false; # tests require fetching node_modules

  pythonImportsCheck = [ "webpack_loader" ];

  meta = {
    description = "Use webpack to generate your static bundles";
    homepage = "https://github.com/owais/django-webpack-loader";
    changelog = "https://github.com/django-webpack/django-webpack-loader/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
  };
})
