{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  justbases,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "justbytes";
  version = "0.15.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mulkieran";
    repo = "justbytes";
    tag = "v${version}";
    hash = "sha256-Ardkinh5l0ud57MWLc+ii0xPwo1MgXIioYDrr8jC0ds=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    justbases
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  meta = {
    description = "Computing with and displaying bytes";
    homepage = "https://github.com/mulkieran/justbytes";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
