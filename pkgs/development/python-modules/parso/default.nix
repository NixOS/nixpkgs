{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.8.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "parso";
    tag = "v${version}";
    hash = "sha256-faSXCrOkybLr0bboF/8rPV/Humq8s158A3UOpdlYi0I=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/master/CHANGELOG.rst";
    license = licenses.mit;
  };
}
