{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, build
, git
<<<<<<< HEAD
, pytest-mock
, pytestCheckHook
, setuptools
, tomli-w
=======
, importlib-metadata
, pep517
, pytest-mock
, pytestCheckHook
, setuptools
, tomlkit
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, virtualenv
}:

buildPythonPackage rec {
  pname = "poetry-core";
<<<<<<< HEAD
  version = "1.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "1.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Gc22Y2T4uO39jiOqEUFeOfnVCbknuDjmzFPZgk2eY74=";
=======
    hash = "sha256-h3d0h+WCrrNlfPOlUx6Rj0aG6untD6MiunqvPj4yT+0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # revert update of vendored dependencies to unbreak e.g. zeroconf on x86_64-darwin
  patches = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    (fetchpatch {
<<<<<<< HEAD
      url = "https://github.com/python-poetry/poetry-core/commit/0bdf29e9631fda9436066a07ca8e69a4aa97a31e.patch";
      revert = true;
      hash = "sha256-Uqlv17GUcmVkB6ZFePtrbUonsbkiIXay7LLuT/WcPh8=";
    })
    (fetchpatch {
      url = "https://github.com/python-poetry/poetry-core/commit/48447a18a60c43240bf075fc0c2501f6d68f0211.patch";
      revert = true;
      hash = "sha256-23GazppqYmuAmkE/xMtuzng2PbxhYNwgtmsvb6lfvig=";
    })
    (fetchpatch {
      url = "https://github.com/python-poetry/poetry-core/commit/bc97ac6030049a01e5337fcb53493112a9c75a81.patch";
      revert = true;
      hash = "sha256-8NAG+Xm/BNL16NONZJRNB3JiRRKvjMsZJH2FWlw+dHk=";
    })
    (fetchpatch {
      url = "https://github.com/python-poetry/poetry-core/commit/835bc91393fbb983de6227d67b076aea1360ea68.patch";
      revert = true;
      hash = "sha256-Z5viypprDY9GGeX6luBsIoSI9D0lN9g14U9uMh4DTfA=";
    })
    (fetchpatch {
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      url = "https://github.com/python-poetry/poetry-core/commit/80d7dcdc722dee0e09e5f3303b663003d794832c.patch";
      revert = true;
      hash = "sha256-CPjkNCmuAiowp/kyKqnEfUQNmXK95RMJOIa24nG6xi8=";
    })
    (fetchpatch {
      url = "https://github.com/python-poetry/poetry-core/commit/43fd7fe62676421b3661c96844b5d7cf49b87c07.patch";
<<<<<<< HEAD
      excludes = [
        "vendors/poetry.lock"
        "vendors/pyproject.toml"
      ];
      revert = true;
      hash = "sha256-mbu16qFH9ymDZ0KIMiYMy7js5OmxY7z5qg6ZfgfgeLs=";
    })
  ];

  nativeCheckInputs = [
    build
    git
    pytest-mock
    pytestCheckHook
    setuptools
    tomli-w
=======
      revert = true;
      hash = "sha256-fXq8L23qjLraLeMzB1bwW1jU0eGd236/GHIoYKwOuL0=";
    })
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    build
    git
    pep517
    pytest-mock
    pytestCheckHook
    setuptools
    tomlkit
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    virtualenv
  ];

  # Requires git history to work correctly
  disabledTests = [
    "default_with_excluded_data"
    "default_src_with_excluded_data"
  ];

  pythonImportsCheck = [
    "poetry.core"
  ];

  # Allow for package to use pep420's native namespaces
  pythonNamespaces = [
    "poetry"
  ];

<<<<<<< HEAD
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-int-conversion";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    changelog = "https://github.com/python-poetry/poetry-core/blob/${src.rev}/CHANGELOG.md";
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
