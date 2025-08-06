{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mediainfo.yazi";
  version = "25.5.31-unstable-2025-07-19";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "mediainfo.yazi";
    rev = "f89605ce7ca33181ee6770e641d80ec4673093e0";
    hash = "sha256-NloChkZWKo9JL636d+G7vgEY/HX24udngYftw/Ydzk4=";
  };

  meta = {
    description = "Yazi plugin for previewing media files";
    homepage = "https://github.com/boydaihungst/mediainfo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
