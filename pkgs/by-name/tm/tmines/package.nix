{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "tmines";
  version = "1.0.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "colepearson27";
    repo = "tmines";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u1cP7akKt0YQZKGHZlwsvXGgQ2TLLMnsWuRKSNY086U=";
  };

  vendorHash = "sha256-gEu57cKAPJRfzbx6tI7BycazzpgP3VIpr+B9nbZhIu8=";

  meta = {
    description = "Simple terminal based minesweeper project.";
    homepage = "github.com/colepearson27/tmines";
    maintainers = with lib.maintainers; [ colepearson27 ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
