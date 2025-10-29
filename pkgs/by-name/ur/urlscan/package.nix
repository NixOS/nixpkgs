{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "urlscan";
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "urlscan";
    tag = version;
    hash = "sha256-grQZ1dYa6OII1ah2FWOZg17rnTV/wfzXUtV3ijE8oDE=";
  };

  build-system = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3.pkgs; [ urwid ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "urlscan" ];

  meta = {
    description = "Mutt and terminal url selector (similar to urlview)";
    homepage = "https://github.com/firecat53/urlscan";
    changelog = "https://github.com/firecat53/urlscan/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dpaetzel ];
    mainProgram = "urlscan";
  };
}
