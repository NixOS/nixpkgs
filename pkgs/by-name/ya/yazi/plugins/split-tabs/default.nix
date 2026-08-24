{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:

mkYaziPlugin {
  pname = "split-tabs.yazi";
  version = "0-unstable-2026-08-18";

  src = fetchFromGitHub {
    owner = "terrakok";
    repo = "split-tabs.yazi";
    rev = "d0531f49503003d669b98ebd468f5dddb90391ba";
    hash = "sha256-25PnsplMhF9satXHA1Ow0bZSksoLwH2zpuqrEZ2aFjQ=";
  };

  meta = {
    description = "Yazi plugin that provides a dual-pane view by splitting the screen between two tabs";
    homepage = "https://github.com/terrakok/split-tabs.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
