{ lib
, buildPythonPackage
, fetchFromGitHub
, markdown
, mkdocs
, pytestCheckHook
<<<<<<< HEAD
, pdm-backend
=======
, pdm-pep517
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mkdocs-autorefs";
<<<<<<< HEAD
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "autorefs";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-GZKQlOXhQIQhS/z4cbmS6fhAKYgnVhSXh5a8Od7+TWc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    pdm-backend
=======
    rev = version;
    hash = "sha256-kiHb/XSFw6yaUbLJHBvHaQAOVUM6UfyFeomgniDZqgU=";
  };

  nativeBuildInputs = [
    pdm-pep517
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    markdown
    mkdocs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "mkdocs_autorefs"
  ];

  meta = with lib; {
    description = "Automatically link across pages in MkDocs";
    homepage = "https://github.com/mkdocstrings/autorefs/";
<<<<<<< HEAD
    changelog = "https://github.com/mkdocstrings/autorefs/blob/${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
