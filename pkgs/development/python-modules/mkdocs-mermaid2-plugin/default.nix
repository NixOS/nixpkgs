<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
=======
{ lib, buildPythonPackage, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, beautifulsoup4
, jsbeautifier
, mkdocs
, mkdocs-material
, pymdown-extensions
, pyyaml
, requests
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "mkdocs-mermaid2-plugin";
<<<<<<< HEAD
  version = "1.0.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "mkdocs-mermaid2-plugin";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-0h/EMfp6D14ZJcQe3U2r/RQ/VNejOK9bLP6AMNiB0Rc=";
=======
    rev = "v${version}";
    hash = "sha256-Oe6wkVrsB0NWF+HHeifrEogjxdGPINRDJGkh9p+GoHs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    beautifulsoup4
    jsbeautifier
    mkdocs
    mkdocs-material
    pymdown-extensions
    pyyaml
    requests
  ];

  # non-traditional python tests (e.g. nodejs based tests)
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "mermaid2"
  ];
=======
  pythonImportsCheck = [ "mermaid2" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A MkDocs plugin for including mermaid graphs in markdown sources";
    homepage = "https://github.com/fralau/mkdocs-mermaid2-plugin";
<<<<<<< HEAD
    changelog = "https://github.com/fralau/mkdocs-mermaid2-plugin/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
