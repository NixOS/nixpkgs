{
  lib,
  fetchFromGitHub,
  python3,
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # Doesn't work with latest paramiko
      paramiko = super.paramiko.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.0";
        src = fetchFromGitHub {
          owner = "paramiko";
          repo = "paramiko";
          tag = version;
          hash = "sha256-V0s9IoRmqXvzYQzzBsWmovYWwXnNC0x1phyiyjbejGA=";
        };
        doCheck = false;
        meta = oldAttrs.meta // {
          knownVulnerabilities = [
            "CVE-2026-44405"
          ];
        };
      });
    };
  };
in
py.pkgs.buildPythonApplication (finalAttrs: {
  pname = "tunnelgraf";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "denniswalker";
    repo = "tunnelgraf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6t/rUdz0RyxWxZM0QO1ynRTNQq4GZMIAxMYBB2lfA54=";
  };

  pythonRelaxDeps = [
    "click"
    "deepmerge"
    "psutil"
    "pydantic"
    "python-hosts"
    "wcwidth"
  ];

  build-system = with py.pkgs; [ hatchling ];

  dependencies = with py.pkgs; [
    click
    deepmerge
    paramiko
    psutil
    pydantic
    python-hosts
    pyyaml
    sshtunnel
    wcwidth
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "tunnelgraf" ];

  meta = {
    description = "Tool to manage SSH tunnel hops to many endpoints";
    homepage = "https://github.com/denniswalker/tunnelgraf";
    changelog = "https://github.com/denniswalker/tunnelgraf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tunnelgraf";
  };
})
