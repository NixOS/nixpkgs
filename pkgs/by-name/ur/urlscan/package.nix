{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "urlscan";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firecat53";
    repo = "urlscan";
    tag = finalAttrs.version;
    hash = "sha256-Jykv08XKloVioHLpe3uLje7lGiQHL/EcjEUkhBOeV2k=";
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
    changelog = "https://github.com/firecat53/urlscan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dpaetzel ];
    mainProgram = "urlscan";
  };
})
