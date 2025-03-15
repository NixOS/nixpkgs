{ pkgs ? import <nixpkgs> {} }: let
  python3Packages = pkgs.python3Packages;

  textual-0_86_2 = python3Packages.buildPythonPackage rec {
    pname = "textual";
    version = "2.1.2";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-quP5/eAMdEC+AOPDrBieAtAU9SmK/cMhMvk0gPngkUY=";
    };

    propagatedBuildInputs = with python3Packages; [
      rich
      platformdirs
      typing-extensions
      linkify-it-py
    ];

    pyproject = true;
    nativeBuildInputs = with python3Packages; [
      poetry-core
    ];
  };

  textual-autocomplete = python3Packages.buildPythonPackage rec {
    pname = "textual_autocomplete";
    version = "4.0.0a0";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-wsjmgODvFgfbyqxW3jsH88JC8z0TZQOChLgics7wAHY=";
    };

    propagatedBuildInputs = [
      textual-2_1_2
    ];

    format = "pyproject";
    nativeBuildInputs = [
      hatchling
    ];
  };

in python3Packages.buildPythonPackage rec {
  pname = "posting";
  version = "2.3.0";

  src = python3Packages.fetchFromGitHub {
    owner = "darrenburns";
    repo = "posting";
    rev = version;
    sha256 = "sha256-lL85gJxFw8/e8Js+UCE9VxBMcmWRUkHh8Cq5wTC93KA=";
  };

    nativeBuildInputs = [
      hatchling
    ];

    propagatedBuildInputs = with python3Packages; [
      httpx
      textual-2_1_2
      textual-autocomplete
      openapi-pydantic
      click
      xdg-base-dirs
      click-default-group
      pyperclip
      pyyaml
      pydantic-settings
      python-dotenv
      watchfiles
      rich
      toml
      pydantic
      typer
    ];

  format = "pyproject";
  doCheck = false;
  pythonImportsCheck = ["posting"];

    meta = with pkgs.lib; {
      description = "Command-line HTTP client";
      homepage = "https://github.com/darrenburns/posting";
      license = licenses.mit;
      maintainers = [lib.maintainers.blackzeshi];
    };
  }
