{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  justbases,
  unittestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "justbytes";
  version = "0.15.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mulkieran";
    repo = "justbytes";
    tag = "v${version}";
    hash = "sha256-+jwIK1ZU+j58VoOfZAm7GdFy7KHU28khwzxhYhcws74=";
  };

  propagatedBuildInputs = [ justbases ];
  nativeCheckInputs = [
    unittestCheckHook
    hypothesis
  ];

  meta = {
    description = "Computing with and displaying bytes";
    homepage = "https://github.com/mulkieran/justbytes";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
