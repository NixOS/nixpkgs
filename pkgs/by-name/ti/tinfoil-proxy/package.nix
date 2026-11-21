{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "tinfoil-proxy";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "tinfoilsh";
    repo = "tinfoil-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rlAEWdxgpGNDAb1nm32bdFvb9FfK4CSVyO/yyZKvmEo=";
  };

  vendorHash = "sha256-zv7OQEWxiJXWOwkEoiMgLoj1T4x9X9i6njPxK8EVpbg=";

  __structuredAttrs = true;

  meta = {
    description = "Local proxy that secures connections to Tinfoil enclaves";
    homepage = "https://github.com/tinfoilsh/tinfoil-proxy";
    changelog = "https://github.com/tinfoilsh/tinfoil-proxy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.lothan ];
    mainProgram = "tinfoil-proxy";
    platforms = lib.platforms.unix;
  };
})
