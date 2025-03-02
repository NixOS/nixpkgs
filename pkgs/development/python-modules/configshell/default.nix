{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pyparsing,
  six,
  urwid,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "configshell";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    tag = "v${version}";
    hash = "sha256-lP3WT9ASEj6WiCrurSU/e9FhIaeoQW/n9hi1XZMnV4Q=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    pyparsing
    six
    urwid
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "configshell" ];

  meta = with lib; {
    description = "Python library for building configuration shells";
    homepage = "https://github.com/open-iscsi/configshell-fb";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
