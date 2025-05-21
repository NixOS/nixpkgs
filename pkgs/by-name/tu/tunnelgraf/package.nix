{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
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
    "paramiko"
    "psutil"
    "pydantic"
  ];

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
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

  meta = with lib; {
    description = "Tool to manage SSH tunnel hops to many endpoints";
    homepage = "https://github.com/denniswalker/tunnelgraf";
    changelog = "https://github.com/denniswalker/tunnelgraf/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "tunnelgraf";
  };
}
