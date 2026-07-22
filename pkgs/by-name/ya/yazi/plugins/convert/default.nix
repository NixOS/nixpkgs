{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "convert.yazi";
  version = "0-unstable-2025-06-28";

  src = fetchFromGitHub {
    owner = "atareao";
    repo = "convert.yazi";
    rev = "ce060d9d17e4466d7956213d68a7a74d24ecfdc5";
    hash = "sha256-kCXjwtcOQZbE+S9PgJrBmlzBcdprSGtfiS2Flxe2olw=";
  };

  meta = {
    description = "Convert between image formats using ImageMagick";
    homepage = "https://github.com/atareao/convert.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nemeott ];
  };
}
