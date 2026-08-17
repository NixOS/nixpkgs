{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "gitui.yazi";
  version = "0-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "gclarkjr5";
    repo = "gitui.yazi";
    rev = "b3362f54db9c0da51b1d4fb2fe8315a0dada7274";
    hash = "sha256-lNj5dH6LDvl9TlA7/+bnDrRMlpOE0bCW3umrW3gBpP8=";
  };

  meta = {
    description = "Plugin for Yazi to manage git repos with gitui";
    homepage = "https://github.com/gclarkjr5/gitui.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felipe-9 ];
  };
}
