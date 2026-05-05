{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  uv-build,
  asyncgui,
  kivy,
}:
buildPythonPackage rec {
  pname = "asynckivy";
  version = "v0.9.3";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asyncgui";
    repo = "asynckivy";
    rev = version;
    hash = "sha256-azGeruQQ6Ghg+P9AEyNrIgxB+RtF9U1BY+5hMXSJ8uc=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    asyncgui
    kivy
  ];
  pythonRelaxDeps = [ "asyncgui" ];

  doChecks = false; # Tests require an available video device

  meta = with lib; {
    description = "Async library for Kivy";
    homepage = "https://asyncgui.github.io/asynckivy";
    license = licenses.mit;
    maintainers = with maintainers; [ iofq ];
  };
}
