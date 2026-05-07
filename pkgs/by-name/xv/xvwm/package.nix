{
  lib,
  fetchFromGitea,
  dwm,
}:

dwm.overrideAttrs (oldAttrs: {
  pname = "xvwm";
  version = "2.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "wh1tepearl";
    repo = "vxwm";
    rev = "fcd4b314c820030f4883d3ac43434e3bf92ab895";
    hash = "sha256-NgUMODXr4ijoxS6WVxeMCdhcgzVCFfotq/o1USV3LOQ=";
  };

  meta = oldAttrs.meta // {
    homepage = "https://codeberg.org/wh1tepearl/vxwm";
    description = "Versatile X Window Manager for X11 forked from dwm.";
    mainProgram = "vxwm";
    maintainers = with lib.maintainers; [ sophimoo ];
  };
})
