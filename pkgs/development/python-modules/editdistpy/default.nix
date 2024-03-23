{ lib
, buildPythonPackage
, fetchFromGitHub

, pytestCheckHook

, pythonOlder

, setuptools
, cython_3

, symspellpy
, numpy
, editdistpy
}:

buildPythonPackage rec {
  pname = "editdistpy";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mammothb";
    repo = "editdistpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-4CtKadKpFmlZnz10NG0404oFl9DkdQwWwRSWgUPdh94=";
  };

  build-system = [
    setuptools
    cython_3
  ];

  # error: infinite recursion encountered
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    symspellpy
    numpy
  ];

  preCheck = ''
    rm -r editdistpy
  '';

  passthru.tests = {
    check = editdistpy.overridePythonAttrs (
      _: {
        doCheck = true;
      }
    );
  };

  pythonImportsCheck = [
    "editdistpy"
  ];

  meta = with lib;
    {
      description = "Fast Levenshtein and Damerau optimal string alignment algorithms";
      homepage = "https://github.com/mammothb/editdistpy";
      changelog = "https://github.com/mammothb/editdistpy/releases/tag/v${version}";
      license = licenses.mit;
      maintainers = with maintainers; [ vizid ];
    };
}
