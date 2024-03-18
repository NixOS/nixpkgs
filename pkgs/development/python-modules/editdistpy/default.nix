{ lib
, buildPythonPackage
, fetchFromGitHub

, pythonOlder

, setuptools
, cython_3
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

  # for tests need symspellpy package, symspellpy is not in nixpkgs...
  doCheck = false;

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
