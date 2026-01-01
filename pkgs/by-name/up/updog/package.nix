{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "updog";
<<<<<<< HEAD
  version = "2.0.1";
=======
  version = "1.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sc0tfree";
    repo = "updog";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-EFAqxlKrQ9HBMHBdmstY+RZPqK0kWY5Ws6WMFHlMyM0=";
  };

  build-system = [
    python3Packages.poetry-core
=======
    tag = version;
    hash = "sha256-e6J4Cbe9ZRb+nDMi6uxwP2ZggbNDyKysQC+IcKCDtIw=";
  };

  build-system = [
    python3Packages.setuptools
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  dependencies = with python3Packages; [
    colorama
    flask
<<<<<<< HEAD
    flask-cors
    flask-httpauth
    pyopenssl
    werkzeug
  ];

  pythonRelaxDeps = [
    "pyopenssl"
    "flask-cors"
  ];

  nativeCheckInputs = [ versionCheckHook ];
=======
    flask-httpauth
    werkzeug
    pyopenssl
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # no python tests

  meta = {
    description = "Replacement for Python's SimpleHTTPServer";
    mainProgram = "updog";
    homepage = "https://github.com/sc0tfree/updog";
<<<<<<< HEAD
    changelog = "https://github.com/sc0tfree/updog/releases/tag/v${version}";
=======
    changelog = "https://github.com/sc0tfree/updog/releases/tag/${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
