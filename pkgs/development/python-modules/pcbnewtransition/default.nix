{
  pythonOlder,
  buildPythonPackage,
  fetchPypi,
  lib,
  kicad,
  versioneer,
}:
buildPythonPackage rec {
  pname = "pcbnewtransition";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pcbnewTransition";
    inherit version;
    hash = "sha256-4XNcnQzUWpY0NEfS2bdtkedvG4lY79jaPe0QqTWNW6s=";
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
