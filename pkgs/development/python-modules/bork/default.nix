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
  version = "7.0.2";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "duckinator";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sHCPT6nTenE6mbTifNPtg0OMNIJCs7LRcF8Xuk+MwLs=";
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
