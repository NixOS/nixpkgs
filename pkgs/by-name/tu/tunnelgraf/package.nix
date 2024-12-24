{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tunnelgraf";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "denniswalker";
    repo = "tunnelgraf";
    rev = "refs/tags/v${version}";
    hash = "sha256-pwHP9eAf2S08ucUawxrQvzMBJNITxbddoLzEoSNUdao=";
  };

  pythonRelaxDeps = [
    "click"
    "paramiko"
    "pydantic"
  ];

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    click
    deepmerge
    paramiko
    pydantic
    python-hosts
    pyyaml
    sshtunnel
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
