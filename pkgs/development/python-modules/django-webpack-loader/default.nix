{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-webpack-loader";
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-webpack";
    repo = "django-webpack-loader";
    tag = version;
    hash = "sha256-ZT+c6oYpES+3idHO1Dty3r8DHGNtD44ljEbBVOlEmW0=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  doCheck = false; # tests require fetching node_modules

  pythonImportsCheck = [ "webpack_loader" ];

  meta = with lib; {
    description = "Use webpack to generate your static bundles";
    homepage = "https://github.com/owais/django-webpack-loader";
    changelog = "https://github.com/django-webpack/django-webpack-loader/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
  };
}
