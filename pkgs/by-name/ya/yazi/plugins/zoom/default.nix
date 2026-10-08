{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "zoom.yazi";
  version = "0-unstable-2026-06-20";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "38efe09c270162f1b0dfb6020e021a5b64bdc735";
    hash = "sha256-rgelX8Aj6iPYzk3NZN5NLMiJ/dQKJD2BKXsrK6xXdkc=";
  };

  meta = {
    description = "Enlarge or shrink the preview image of a file, which is useful for magnifying small files for viewing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ saadndm ];
  };
}
