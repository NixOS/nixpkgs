{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yyjson";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "ibireme";
    repo = "yyjson";
    tag = finalAttrs.version;
    hash = "sha256-1CYnEgUMUc7eqdkv6M/KyL/MdVQBMov9HgLCycF6++w=";
  };

  nativeBuildInputs = [
    cmake
  ];

  patches = [
    # https://github.com/ibireme/yyjson/pull/295
    (fetchpatch {
      url = "https://github.com/ibireme/yyjson/commit/bef00cb5fe1929944cc13dec13f0f23fa4ad568b.patch";
      hash = "sha256-oRFN95sgLqiwCzxvC3G4CFsD6sJtI5NeBWp4/WeaKCc=";
    })
  ];

  meta = {
    description = "Fastest JSON library in C";
    homepage = "https://github.com/ibireme/yyjson";
    changelog = "https://github.com/ibireme/yyjson/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
})
