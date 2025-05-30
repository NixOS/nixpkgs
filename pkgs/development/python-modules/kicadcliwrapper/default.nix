{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "kicadcliwrapper";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "kicadcliwrapper";
    tag = "v${version}";
    hash = "sha256-S1Sd3TgLUIT1TcG8WbEgHgUqIcXvzVdvfwrPnpaK7/g=";
  };

  # this script is used the generated the bindings
  # and is intended for development.
  preCheck = ''
    rm src/kicadcliwrapper/main.py
  '';

  build-system = [ poetry-core ];

  dependencies = [ typing-extensions ];

  pythonRemoveDeps = [ "black" ];

  pythonImportsCheck = [
    "kicadcliwrapper"
    "kicadcliwrapper.lib"
  ];

  doCheck = false; # no tests

  meta = {
    description = "Strongly typed, auto-generated bindings for KiCAD's CLI";
    homepage = "https://github.com/atopile/kicadcliwrapper";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
