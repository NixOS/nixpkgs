{
  lib,
  buildDunePackage,
  fetchurl,
  fetchpatch,
  applyPatches,
}:

buildDunePackage (finalAttrs: {
  pname = "owl-base";
  version = "1.2";

  src = applyPatches {
    src = fetchurl {
      url = "https://github.com/owlbarn/owl/releases/download/${finalAttrs.version}/owl-${finalAttrs.version}.tbz";
      hash = "sha256-OBei5DkZIsiiIltOM8qV2mgJJGmU5r8pGjAMgtjKxsU=";
    };

    patches = [
      # Compatibility with GCC 15
      (fetchpatch {
        url = "https://github.com/owlbarn/owl/commit/3e66ccb0b1d21b73fa703f3d3f416ec0107860a4.patch";
        hash = "sha256-0bV0ogTvtDoO8kEvE5QcJFRWqOJ1qiXGjXY9Ekp30M0=";
      })
    ];
  };

  minimalOCamlVersion = "4.10";

  meta = {
    description = "Numerical computing library for Ocaml";
    homepage = "https://ocaml.xyz";
    changelog = "https://github.com/owlbarn/owl/releases";
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = [ lib.maintainers.bcdarwin ];
    license = lib.licenses.mit;
  };
})
