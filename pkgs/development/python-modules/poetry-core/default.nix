{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, isPy27
, git
, importlib-metadata
, intreehooks
, pathlib2
, pep517
, pytest-mock
, pytestCheckHook
, tomlkit
, typing ? null
, virtualenv
}:

buildPythonPackage rec {
  pname = "poetry-core";
  version = "1.0.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    sha256 = "sha256-cs9SMGD9RdW8Wx/IAMq6gkOUBsney5r19hyGva98grk=";
  };

  postPatch = lib.optionalString (pythonOlder "3.8") ''
    # remove >1.0.3
    substituteInPlace pyproject.toml \
      --replace 'importlib-metadata = {version = "^1.7.0", python = "~2.7 || >=3.5, <3.8"}' \
        'importlib-metadata = {version = ">=1.7.0", python = "~2.7 || >=3.5, <3.8"}'
  '';

  nativeBuildInputs = [
    intreehooks
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals isPy27 [
    pathlib2
    typing
  ];

  checkInputs = [
    git
    pep517
    pytest-mock
    pytestCheckHook
    tomlkit
    virtualenv
  ];

  # requires git history to work correctly
  disabledTests = [ "default_with_excluded_data" "default_src_with_excluded_data" ];

  pythonImportsCheck = [ "poetry.core" ];

  # allow for package to use pep420's native namespaces
  pythonNamespaces = [ "poetry" ];

  meta = with lib; {
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
