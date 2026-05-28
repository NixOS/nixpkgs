{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-switch";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mostafaqanbaryan";
    repo = "zellij-switch";
    tag = finalAttrs.version;
    hash = "sha256-IPg0pBw0ciF+xl6viq3nK+dvZoDZrfBDui7dkPLz258=";
  };

  cargoHash = "sha256-Fv8PRfVzIOTHHChXBy9rkrnu7/bD07a+sQJlLw9Qwgc=";

  meta = {
    description = "Switch between sessions in CLI using `zellij pipe`";
    homepage = "https://github.com/mostafaqanbaryan/zellij-switch";
    license = lib.licenses.unfree; # https://github.com/mostafaqanbaryan/zellij-switch/pull/14
  };
})
