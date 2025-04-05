{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-rerunfailures,
  pytestCheckHook,
  setuptools,
  python-dateutil,
  pyyaml,
  empy,
  distlib,
  packaging,
}:
buildPythonPackage rec {
  pname = "colcon-core";
  version = "0.19.0";
  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-core";
    rev = "f1d3055b2c39abb7b6e272c1cafbaf95780fd9a7";
    sha256 = "sha256-R/TVHPT305PwaVSisP0TtbgjCFBwCZkXOAgkYhCKpyY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    python-dateutil
    pyyaml
    empy
    distlib
    packaging
  ];

  checkInputs = [

    pytest-rerunfailures
    pytestCheckHook
  ];

  # Skip the linter and spell check tests that require additional dependencies
  pytestFlagsArray = [
    "--ignore=test/test_flake8.py"
    "--ignore=test/test_spell_check.py"
  ];

  pythonImportsCheck = [ "colcon_core" ];

  meta = with lib; {
    description = "Command line tool to build sets of software packages";
    homepage = "https://github.com/colcon/colcon-core";
    license = licenses.asl20;
    maintainers = with maintainers; [ guelakais ];
  };
}
