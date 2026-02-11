{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  fetchpatch,
  multimarkdown,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vixl";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "Linaro";
    repo = "vixl";
    tag = finalAttrs.version;
    hash = "sha256-VW4Zoh4L8AXoL2kgthAtHkrTnoKpSa9MsBTEGROUrj4=";
  };

  # Add missing meson build support
  # See: https://github.com/Linaro/vixl/pull/7
  patches = [ ./add_missing_meson_support.patch ];

  nativeBuildInputs = [
    meson
    multimarkdown
    ninja
    pkg-config
  ];

  strictDeps = true;

  meta = {
    description = "AArch32 and AArch64 runtime code generation library";
    homepage = "https://github.com/Linaro/vixl";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ onny ];
  };
})
