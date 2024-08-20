{
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  kicad,
  versioneer,
}:
buildPythonPackage rec {
  pname = "pcbnewtransition";
  version = "0.4.1-unstable-2024-06-05"; # There hasn't been a release yet with Python 3.12 support: https://github.com/yaqwsx/pcbnewTransition/issues/7
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "yaqwsx";
    repo = "pcbnewTransition";
    rev = "c01829807de18cddc6d735d04bab5fafa67dd95f";
    hash = "sha256-1iub9t5YILtaSQdmUmVNYzPdvfjPlt7LQNxM7wRqas4=";
  };

  propagatedBuildInputs = [ kicad ];

  nativeBuildInputs = [ versioneer ];

  pythonImportsCheck = [ "pcbnewTransition" ];

  meta = with lib; {
    description = "Library that allows you to support both, KiCad 5, 6 and 7 in your plugins";
    homepage = "https://github.com/yaqwsx/pcbnewTransition";
    changelog = "https://github.com/yaqwsx/pcbnewTransition/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      jfly
      matusf
    ];
  };
}
