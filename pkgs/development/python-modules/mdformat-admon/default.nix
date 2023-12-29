{ lib
, buildPythonPackage
, fetchFromGitHub
, mdformat
, python3
, pythonOlder
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      mdit-py-plugins = super.mdit-py-plugins.overridePythonAttrs (_prev: rec {
      version = "0.4.0";
      doCheck = false;
      src = fetchFromGitHub {
        owner = "executablebooks";
        repo = "mdit-py-plugins";
        rev = "refs/tags/v${version}";
        hash = "sha256-YBJu0vIOD747DrJLcqiZMHq34+gHdXeGLCw1OxxzIJ0=";
      };
    });
    };
  };
in python.pkgs.buildPythonPackage rec {
  pname = "mdformat-admon";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-33Q3Re/axnoOHZ9XYA32mmK+efsSelJXW8sD7C1M/jU=";
  };

  nativeBuildInputs = with python.pkgs; [
    flit-core
  ];

  buildInputs = with python.pkgs; [
    mdformat
  ];

  propagatedBuildInputs = with python.pkgs; [
    mdit-py-plugins
  ];

  meta = with lib; {
    description = "mdformat plugin for admonitions";
    homepage = "https://github.com/KyleKing/mdformat-admon";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
