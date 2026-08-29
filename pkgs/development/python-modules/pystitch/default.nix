{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pystitch";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inkstitch";
    repo = "pystitch";
    rev = "8fc0b113e02ea81d9a507bfad3f7fd624a8895bd";
    hash = "sha256-fVJ2RvrCrGl2k8YMjr6wTShqB8iSZBN5WaYdQ4F/iWc=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python library for the reading and writing of embroidery files";
    homepage = "https://github.com/inkstitch/pystitch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pluiedev
      tropf
    ];
  };
}
