{ lib, buildPythonApplication, fetchPypi, fetchFromGitHub, python }:

let
  py = python.override {
    packageOverrides = self: super: {
      lark-parser = super.lark-parser.overridePythonAttrs (oldAttrs: rec {
        version = "0.8.0";
        src = fetchFromGitHub {
          owner = "lark-parser";
          repo = "lark";
          rev = version;
          sha256 = "sha256-su7kToZ05OESwRCMPG6Z+XlFUvbEb3d8DgsTEcPJMg4=";
        };
      });
    };
  };
in with py.pkgs;
buildPythonApplication rec {
  pname = "gdtoolkit";
  version = "3.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y3NlBKKmHeL96dbHsaaIjHkLfc4L5k6seMSHEkN24+A=";
  };

  propagatedBuildInputs = [ docopt pyyaml lark-parser ];

  checkInputs = [ js2py ];
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://github.com/Scony/godot-gdscript-toolkit";
    description =
      "Independent set of GDScript tools - parser, linter and formatter";
    license = licenses.mit;
    maintainers = [ payas ];
  };
}
