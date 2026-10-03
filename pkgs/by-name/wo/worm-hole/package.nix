{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worm-hole";
  version = "4.2.0";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "Rignchen";
    repo = "worm_hole";
    tag = finalAttrs.version;
    hash = "sha256-PcyvmpiagjLSJgAr1NPI5WJu/00sq8QpP+xwCHisRTU=";
  };

  cargoHash = "sha256-SJyDFdxVS9UivE/jhxD98wfQjMjWjnTDG62M1+iZr9A=";

  meta = {
    description = "CLI tool to easily jump between directories";
    homepage = "https://gitlab.com/Rignchen/worm_hole";
    changelog = "https://gitlab.com/Rignchen/worm_hole/-/releases/${finalAttrs.src.tag}";
    mainProgram = "worm_hole";
    maintainers = with lib.maintainers; [ rignchen ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
