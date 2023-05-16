{ lib
, aiofiles
, buildPythonPackage
<<<<<<< HEAD
=======
, cached-property
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, colorama
, fetchFromGitHub
, git
, jsonschema
, pdm-backend
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "griffe";
<<<<<<< HEAD
  version = "0.36.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.26.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-21u6QnmFoa3rCeFMkxdEh4OYtE4QmBr5O9PwV5tKgxg=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
=======
    hash = "sha256-p5JYBVvKvqKdYIYFh8ZiEgepJips9jg/6ao5yZ/fbcs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"' \
      --replace 'license = "ISC"' 'license = {file = "LICENSE"}' \
      --replace 'version = {source = "scm"}' 'license-expression = "ISC"'
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    colorama
<<<<<<< HEAD
=======
  ] ++ lib.optionals (pythonOlder "3.8") [
    cached-property
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    git
    jsonschema
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
  };

  pythonImportsCheck = [
    "griffe"
  ];

  meta = with lib; {
    description = "Signatures for entire Python programs";
    homepage = "https://github.com/mkdocstrings/griffe";
    changelog = "https://github.com/mkdocstrings/griffe/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
