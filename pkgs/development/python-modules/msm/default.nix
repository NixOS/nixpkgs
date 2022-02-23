{ lib
, buildPythonPackage
, fetchFromGitHub

# runtime
, GitPython
, fasteners
, lazy
, pako
, pyxdg
, pyyaml
, requests

# tests
, pytestCheckHook
}:

let
  pname = "msm";
  version = "0.9.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = "mycroft-skills-manager";
    rev = "release/v${version}";
    hash = "sha256-FJ3HJ86yoQvo6lTaWhAbY27fUnKDuiIf82a+9SceXVg=";
  };

  propagatedBuildInputs = [
    GitPython
    fasteners
    lazy
    pako
    pyxdg
    pyyaml
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # fatal: unable to access 'https://github.com/mycroftai/mycroft-skills-manager/': Could not resolve host: github.com
    "--deselect tests/test_main.py::TestMain::test"
    "--deselect tests/test_skill_repo.py::TestSkillRepo::test_read_file"
    "--deselect tests/test_skill_repo.py::TestSkillRepo::test_get_skill_data"
    "--deselect tests/test_skill_repo.py::TestSkillRepo::test_get_shas"
    "--deselect tests/test_skill_repo.py::TestSkillRepo::test_get_default_skill_names"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "msm"
  ];


  meta = with lib; {
    description = "Mycroft Skills Manager";
    longDescription = ''
      Mycroft Skills Manager is a command line tool and a python module
      for interacting with the mycroft-skills repository.

      It allows querying the repository for information (skill listings,
      skill meta data, etc) and of course installing and removing skills
      from the system.
    '';
    homepage = "https://github.com/MycroftAI/mycroft-skills-manager";
    license = licenses.asl20;
    maintainers = teams.mycroft.members;

  };
}
