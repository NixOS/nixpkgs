{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook

, build
, coloredlogs
, packaging
, pip
, toml
, twine
, wheel
}:

buildPythonPackage rec {
  pname = "bork";
  version = "8.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "duckinator";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BDwVhKmZ/F8CvpT6dEI5moQZx8wHy1TwdOl889XogEo=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "packaging"
    "twine"
    "wheel"
  ];

  propagatedBuildInputs = [
    build
    coloredlogs
    packaging
    pip
    toml
    twine
    wheel
  ];

  pythonImportsCheck = [
    "bork"
    "bork.api"
    "bork.cli"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlagsArray = [
    "-m 'not network'"
  ];

  meta = with lib; {
    description = "Python build and release management tool";
    homepage = "https://github.com/duckinator/bork";
    maintainers = with maintainers; [ nicoo ];
    platforms = platforms.all;
  };
}
