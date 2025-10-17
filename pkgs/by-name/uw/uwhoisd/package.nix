{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "uwhoisd";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kgaughan";
    repo = "uwhoisd";
    tag = "v${version}";
    hash = "sha256-ncllROnKFwsSalbkQIOt/sQO0qxybAgxrVnYOC+9InY=";
  };

  build-system = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    requests
  ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Universal WHOIS proxy server";
    homepage = "https://github.com/kgaughan/uwhoisd";
    changelog = "https://github.com/kgaughan/uwhoisd/blob/${src.tag}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
