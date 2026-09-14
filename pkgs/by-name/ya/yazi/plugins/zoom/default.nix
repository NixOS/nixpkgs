{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "zoom.yazi";
  version = "0-unstable-2026-09-09";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "65255958371798cb82643f08ce739a1affc21f07";
    hash = "sha256-QVGXSvkSF7U/mo3iVywxyF/Xj5aXD+wtKGBtXzdQyqo=";
  };

  meta = {
    description = "Enlarge or shrink the preview image of a file, which is useful for magnifying small files for viewing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ saadndm ];
  };
}
