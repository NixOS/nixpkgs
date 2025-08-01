{
  lib,
  stdenv,
  meson,
  pkg-config,
  ninja,
  libdrm,
  version,
  src,
  patches,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libliftoff";
  inherit version src patches;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [ libdrm ];

  meta = {
    description = "Lightweight KMS plane library";
    longDescription = ''
      libliftoff eases the use of KMS planes from userspace without standing in
      your way. Users create "virtual planes" called layers, set KMS properties
      on them, and libliftoff will pick planes for these layers if possible.
    '';
    inherit (finalAttrs.src.meta) homepage;
    changelog = "https://gitlab.freedesktop.org/emersion/libliftoff/-/tags/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      Scrumplex
    ];
  };
})
