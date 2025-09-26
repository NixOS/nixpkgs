{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  typing-extensions,
  pytestCheckHook,
  kicad,
}:

buildPythonPackage rec {
  pname = "kicadcliwrapper";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "kicadcliwrapper";
    tag = "v${version}";
    hash = "sha256-s1j0k6SvZiIHu8PKGTR+GaYUZIlFq5TKYuxoCsvsvUY=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ typing-extensions ];

  pythonRemoveDeps = [ "black" ];

  pythonImportsCheck = [
    "kicadcliwrapper"
    "kicadcliwrapper.lib"
  ];

  # this script is used to generate the bindings
  # and is intended for development.
  preCheck = ''
    rm src/kicadcliwrapper/main.py
  '';

  nativeCheckInputs = [
    pytestCheckHook
    kicad
  ];

  meta = {
    description = "Strongly typed, auto-generated bindings for KiCAD's CLI";
    homepage = "https://github.com/atopile/kicadcliwrapper";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
