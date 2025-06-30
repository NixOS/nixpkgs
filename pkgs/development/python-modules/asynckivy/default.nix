{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  asyncgui,
  kivy,
}:
buildPythonPackage rec {
  pname = "asynckivy";
  version = "0.8.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asyncgui";
    repo = "asynckivy";
    rev = version;
    hash = "sha256-clJRQgl/r3uDP3ARFjSF0b/glfqlC0939XKt08xuTT4=";
  };

  nativeBuildInputs = [ poetry-core ];

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
