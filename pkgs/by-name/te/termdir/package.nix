{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "termdir";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "t4ce";
    repo = "texplo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E6KFkMra90APBF/UoSP3oUWGYE6+5tAaW43PVxB8y20=";
  };

  cargoHash = "sha256-RGRZ/uMlG8SroXTWss/pq57VBZZcWpHmTNiVKM9+aKI=";

  meta = {
    description = "Fast terminal directory explorer";
    homepage = "https://github.com/t4ce/texplo";
    changelog = "https://github.com/t4ce/texplo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.t4ce ];
    mainProgram = "td";
    platforms = lib.platforms.unix;
  };
})
