{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-webpack-loader";
<<<<<<< HEAD
  version = "3.2.3";
=======
  version = "3.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-webpack";
    repo = "django-webpack-loader";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-W5N6l3GE1OLKLtaBdW0apJ7omlgvsxpPZT4HbIF0Roo=";
=======
    hash = "sha256-ZT+c6oYpES+3idHO1Dty3r8DHGNtD44ljEbBVOlEmW0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools-scm ];

  dependencies = [ django ];

  doCheck = false; # tests require fetching node_modules

  pythonImportsCheck = [ "webpack_loader" ];

<<<<<<< HEAD
  meta = {
    description = "Use webpack to generate your static bundles";
    homepage = "https://github.com/owais/django-webpack-loader";
    changelog = "https://github.com/django-webpack/django-webpack-loader/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
=======
  meta = with lib; {
    description = "Use webpack to generate your static bundles";
    homepage = "https://github.com/owais/django-webpack-loader";
    changelog = "https://github.com/django-webpack/django-webpack-loader/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ peterromfeldhk ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
