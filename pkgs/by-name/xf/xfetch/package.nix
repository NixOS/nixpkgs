{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "xfetch";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xfetch-cli";
    repo = "xfetch";
    rev = "v${version}";
    hash = "sha256-JvQq2T/ljsALYPa/EO/eI3noUDtaEePRrabevShKRM8=";
  };

  sourceRoot = "${src.name}/xfetch";

  cargoHash = lib.fakeHash;

  meta = {
    description = "A fast, customizable system information fetch tool for the terminal";
    homepage = "https://github.com/xfetch-cli/xfetch";
    changelog = "https://github.com/xfetch-cli/xfetch/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "xfetch";
    maintainers = with lib.maintainers; [ xscriptor ];
    platforms = lib.platforms.all;
  };
}
