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
  version = "0.9.0";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asyncgui";
    repo = "asynckivy";
    rev = version;
    hash = "sha256-jlpQhVFdRQGbHu9rsOblk1x8gjUnu7F4GKXtTL5tUxg=";
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
