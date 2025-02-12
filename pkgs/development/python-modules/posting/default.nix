{pkgs ? import <nixpkgs> {}}: let
  textual-0_86_2 = pkgs.python3Packages.buildPythonPackage rec {
    pname = "textual";
    version = "0.86.2";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-Qwc/nrUtDzilry8SS6aLN4+R0mDfSxyS84Sjtcu7y3A=";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [
      rich
      platformdirs
      typing-extensions
      linkify-it-py
    ];

    format = "pyproject";
    nativeBuildInputs = with pkgs.python312Packages; [
      poetry-core
    ];
  };

  textual-autocomplete = pkgs.python3Packages.buildPythonPackage rec {
    pname = "textual_autocomplete";
    version = "3.0.0a13";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-21pK6VbdfW3s5T9/aV6X8qt1gZ3Za4ocBk7Flms6sRM=";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [
      textual-0_86_2
    ];

    format = "pyproject";
    nativeBuildInputs = with pkgs.python312Packages; [
      hatchling
    ];
  };
in
  pkgs.python3Packages.buildPythonPackage rec {
    pname = "posting";
    version = "2.3.0";

    src = pkgs.fetchFromGitHub {
      owner = "darrenburns";
      repo = "posting";
      rev = version;
      sha256 = "sha256-lL85gJxFw8/e8Js+UCE9VxBMcmWRUkHh8Cq5wTC93KA=";
    };

    nativeBuildInputs = with pkgs.python312Packages; [
      hatchling
    ];

    propagatedBuildInputs = with pkgs.python312Packages; [
      httpx
      textual-0_86_2
      textual-autocomplete
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
    };
  }
