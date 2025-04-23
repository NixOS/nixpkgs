{
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  lib,
  monocypher,
  numpy,
  setuptools,
  unittestCheckHook,
}:
let
  version = "4.0.2.5";
in
buildPythonPackage {
  pname = "pymonocypher";
  inherit version;

  pyproject = true;
  build-system = [
    cython
    setuptools
  ];

  src = fetchFromGitHub {
    owner = "jetperch";
    repo = "pymonocypher";
    rev = "v${version}";
    hash = "sha256-3vnF2MnrjI7pRiOTjPZ0D8tDojfdGJ2kSlLqF7Kkp5Y=";
  };

  buildInputs = [ monocypher ];

  doCheck = true;

  pythonImportsCheck = [ "monocypher" ];

  nativeCheckInputs = [ unittestCheckHook ];
  checkInputs = [ numpy ];

  meta = with lib; {
    description = "Python bindings for Monocypher crypto library";
    homepage = "https://github.com/jetperch/pymonocypher";
    license = [
      licenses.bsd2
      licenses.cc0
    ];
    maintainers = with maintainers; [ mightyiam ];
  };
}
