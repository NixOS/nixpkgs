{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "oscpy";
  version = "0.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kivy";
    repo = "oscpy";
    tag = "v${version}";
    hash = "sha256-sumpJ2y9lpd0UhQjk4zVDp3SipBwh3NBkJ3dqWs18IE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oscpy" ];

  meta = {
    description = "Modern implementation of OSC for python2/3";
    mainProgram = "oscli";
    license = lib.licenses.mit;
    homepage = "https://github.com/kivy/oscpy";
    maintainers = [ lib.maintainers.yurkobb ];
  };
}
