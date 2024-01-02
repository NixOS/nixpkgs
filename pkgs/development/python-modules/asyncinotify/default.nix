{ lib
, buildPythonPackage
, fetchFromGitLab
, flit-core
, python
}:

buildPythonPackage rec {
  pname = "asyncinotify";
  version = "4.0.2";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "Taywee";
    repo = "asyncinotify";
    rev = "v${version}";
    hash = "sha256-Q7b406UENCmD9SGbaml+y2YLDi7VLZBmDkYMo8CLuVw=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  checkPhase = ''
    ${python.pythonOnBuildForHost.interpreter} ${src}/test.py
  '';
  pythonImportsCheck = ["asyncinotify"];

  meta = with lib; {
    description = "A simple optionally-async python inotify library, focused on simplicity of use and operation, and leveraging modern Python features";
    homepage = "https://pypi.org/project/asyncinotify/";
    changelog = "https://gitlab.com/Taywee/asyncinotify/-/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
