{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "compress.yazi";
  version = "0-unstable-2026-01-10";

  src = fetchFromGitHub {
    owner = "KKV9";
    repo = "compress.yazi";
    rev = "e6007f7c3f364cdb7146f5b6b282790948fb0bd6";
    hash = "sha256-m5FfN2gnTHsbwP2aYaE+K6kNGfAC7HBVtCyy6HzNRrE=";
  };

  meta = {
    description = "Yazi plugin that compresses selected files to an archive";
    homepage = "https://github.com/KKV9/compress.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
