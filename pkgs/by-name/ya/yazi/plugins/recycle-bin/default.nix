{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "recycle-bin.yazi";
  version = "1.0.0-unstable-2025-08-20";

  src = fetchFromGitHub {
    owner = "uhs-robert";
    repo = "recycle-bin.yazi";
    rev = "3f36069567b4602f841f2377c5f182f9a2480dea";
    hash = "sha256-1z92wbadcnljj019b1r89l38zyd0nnpm22m269502drbj65grlkz";
  };

  meta = {
    description = "A Recycle Bin for Yazi with browse, restore, and cleanup capabilities";
    homepage = "https://github.com/uhs-robert/recycle-bin.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
