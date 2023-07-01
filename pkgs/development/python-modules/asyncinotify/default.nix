{ lib
, buildPythonPackage
, fetchFromGitLab
, python
}:

buildPythonPackage rec {
  pname = "asyncinotify";
  version = "4.0.1";
  format = "flit";

  src = fetchFromGitLab {
    owner = "Taywee";
    repo = "asyncinotify";
    rev = "v${version}";
    hash = "sha256-DMRuj16KjO+0uAB33UCVPdUiQGzri1b/z9KVqQYp2Po=";
  };

  checkPhase = ''
    ${python.pythonForBuild.interpreter} ${src}/test.py
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
