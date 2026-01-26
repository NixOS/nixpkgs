{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  setuptools,
}:
let
  version = "1.1.2";
in
buildPythonPackage {
  pname = "fortune";
  inherit version;
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "jamesansley";
    repo = "fortune";
    tag = "v${version}";
    hash = "sha256-XEWO1B+o0p7mpHprvbdBgfSQrqPuUTaotulcP3FS/Mg=";
  };

  build-system = [ setuptools ];

  meta = {
    description = "A rewrite of fortune in python";
    mainProgram = "fortune";
    homepage = "https://codeberg.org/jamesansley/fortune";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arthsmn ];
  };
}
