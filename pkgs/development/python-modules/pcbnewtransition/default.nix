{
  buildPythonPackage,
  fetchPypi,
  lib,
  kicad,
  versioneer,
}:
buildPythonPackage rec {
  pname = "pcbnewtransition";
  version = "0.5.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname;
    inherit version;
    hash = "sha256-zLnvbu0G2mJKCHLCjbIKHBqSfdEyhR+1afkOFU++TfI=";
  };

  propagatedBuildInputs = [ kicad ];

  nativeBuildInputs = [ versioneer ];

  pythonImportsCheck = [ "pcbnewTransition" ];

  meta = {
    description = "Library that allows you to support both, KiCad 5, 6 and 7 in your plugins";
    homepage = "https://github.com/yaqwsx/pcbnewTransition";
    changelog = "https://github.com/yaqwsx/pcbnewTransition/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jfly
      matusf
    ];
  };
}
