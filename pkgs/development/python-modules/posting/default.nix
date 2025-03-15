{
  buildPythonPackage,
  hatchling,
  pkgs,
  fetchFromGitHub,
  python3Packages,
}: let
  openapi-pydantic = buildPythonPackage rec {
    pname = "openapi_pydantic";
    version = "0.5.0";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-pI+I4pBKBW4e9tRyjPsvNqoyE84ZT7CfwEJZuQBxZfA=";
    };

    propagatedBuildInputs = with python3Packages; [
      pydantic
    ];

    pyproject = true;
    nativeBuildInputs = with python3Packages; [
      poetry-core
    ];
  };

  textual-2_1_2 = buildPythonPackage rec {
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

    pyproject = true;
    nativeBuildInputs = [
      hatchling
    ];
  };
in
  buildPythonPackage rec {
    pname = "posting";
    version = "2.5.4";

    src = fetchFromGitHub {
      owner = "darrenburns";
      repo = "posting";
      rev = version;
      sha256 = "sha256-6nFQSGCdmR4qZuleiY0xh76WgBIjs9OZtfpc16b4iws=";
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

    pyproject = true;
    doCheck = true;
    pythonImportsCheck = ["posting"];

    meta = with pkgs.lib; {
      description = "Command-line HTTP client";
      homepage = "https://github.com/darrenburns/posting";
      license = licenses.mit;
      maintainers = [lib.maintainers.blackzeshi];
    };
  }
