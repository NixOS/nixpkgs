{ lib
, buildPythonPackage
, fetchFromGitHub

# runtime
, GitPython
, PyGithub
, colorama
, msm
, requests
}:

let
  pname = "msm";
  version = "0.3.16";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = "mycroft-skills-kit";
    rev = "v${version}";
    hash = "sha256-yeiDpqaTzFFWXHMyvE8zHWKYoqSEtuU85De9m94+obo=";
  };

  propagatedBuildInputs = [
    GitPython
    PyGithub
    colorama
    msm
    requests
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "msk"
  ];


  meta = with lib; {
    description = "Mycroft Skills Kit";
    longDescription = ''
      A tool to help with creating, uploading, and upgrading Mycroft
      skills on the skills repo.
    '';
    homepage = "https://github.com/MycroftAI/mycroft-skills-kit";
    license = licenses.asl20;
    maintainers = teams.mycroft.members;
  };
}
