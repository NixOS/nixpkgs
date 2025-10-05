{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3,
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # Doesn't work with latest paramiko
      paramiko = super.paramiko.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.0";
        src = fetchPypi {
          pname = "paramiko";
          inherit version;
          hash = "sha256-qsCPJqMdxN/9koIVJ9FoLZnVL572hRloEUqHKPPCdNM=";
        };
        doCheck = false;
      });
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "tunnelgraf";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "denniswalker";
    repo = "tunnelgraf";
    tag = "v${version}";
    hash = "sha256-6t/rUdz0RyxWxZM0QO1ynRTNQq4GZMIAxMYBB2lfA54=";
  };

  pythonRelaxDeps = [
    "click"
    "deepmerge"
    "psutil"
    "pydantic"
    "python-hosts"
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
    changelog = "https://github.com/denniswalker/tunnelgraf/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "tunnelgraf";
  };
}
