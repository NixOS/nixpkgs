{ lib
<<<<<<< HEAD
, beautifulsoup4
, buildPythonPackage
, drawio-headless
, fetchFromGitHub
, mkdocs
, pathspec
, pytestCheckHook
, pythonOlder
=======
, buildPythonPackage
, drawio-headless
, fetchPypi
, pythonOlder
, mkdocs
, beautifulsoup4
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "mkdocs-swagger-ui-tag";
<<<<<<< HEAD
  version = "0.6.4";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "Blueswen";
    repo = "mkdocs-swagger-ui-tag";
    rev = "refs/tags/v${version}";
    hash = "sha256-/Spvj3lt7p+ZUbA/7xaQMLCSmHOOsoCRliqaAN+YU3g=";
=======
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FBrAZ9MhPGPwJhVXslu5mvVIJ7gPDiCK/3EuPAq6RNw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    mkdocs
    beautifulsoup4
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    pathspec
    pytestCheckHook
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "mkdocs_swagger_ui_tag"
  ];

<<<<<<< HEAD
  disabledTests = [
    # Don't actually build results
    "test_material"
    "test_material_dark_scheme_name"
    "test_template"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A MkDocs plugin supports for add Swagger UI in page";
    homepage = "https://github.com/Blueswen/mkdocs-swagger-ui-tag";
    changelog = "https://github.com/blueswen/mkdocs-swagger-ui-tag/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
  };
}
