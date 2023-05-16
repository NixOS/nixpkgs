{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, colorama
, hatch-requirements-txt
, hatch-nodejs-version
, hatchling
, jinja2
, markdown
, mkdocs
, mkdocs-material-extensions
, pygments
, pymdown-extensions
, pythonOlder
, regex
, requests
}:

buildPythonPackage rec {
  pname = "mkdocs-material";
<<<<<<< HEAD
  version = "9.1.13";
=======
  version = "9.1.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-S+cCNcQR8Y1UGj+4Nfy9Z10N/9PRq13fSeR2YFntxWI=";
=======
    hash = "sha256-a0AeRjS0fV4q3z6MPZBBv8Ffv61W3zHPrnPT4evBnaw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatch-requirements-txt
    hatch-nodejs-version
    hatchling
  ];

  propagatedBuildInputs = [
    colorama
    jinja2
    markdown
    mkdocs
    mkdocs-material-extensions
    pygments
    pymdown-extensions
    regex
    requests
  ];

  # No tests for python
  doCheck = false;

  pythonImportsCheck = [
    "mkdocs"
  ];

  meta = with lib; {
    description = "Material for mkdocs";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
