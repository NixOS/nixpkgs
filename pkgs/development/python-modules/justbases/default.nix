{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "justbases";
  version = "0.15.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mulkieran";
    repo = "justbases";
    tag = "v${version}";
    hash = "sha256-5BiX6TD528PP+4fxHC73dmnQIZFRJmO+oH3kBs8TqVw=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  meta = {
    description = "Conversion of ints and rationals to any base";
    homepage = "https://github.com/mulkieran/justbases";
    changelog = "https://github.com/mulkieran/justbases/blob/v${version}/CHANGES.txt";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
