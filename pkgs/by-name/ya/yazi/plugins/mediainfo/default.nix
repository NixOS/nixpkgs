{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mediainfo.yazi";
  version = "0-unstable-2026-08-31";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "mediainfo.yazi";
    rev = "d2dd310bfbc3a819acf1c9c9c32f402ab6774d3a";
    hash = "sha256-nmhn2lcs5F+MRlmqBPbsU74NNiO0Y0Js4YEjRfD9IPE=";
  };

  meta = {
    description = "Yazi plugin for previewing media files";
    homepage = "https://github.com/boydaihungst/mediainfo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
