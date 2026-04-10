{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "flatdict";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gmr";
    repo = "flatdict";
    tag = version;
    hash = "sha256-sLeW92F473H90+EMHaIWPt9ETqSeL/DoLmlMAg9Thj4=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonImportsCheck = [ "flatdict" ];

  meta = {
    description = "Python module for interacting with nested dicts as a single level dict with delimited keys";
    homepage = "https://github.com/gmr/flatdict";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
}
