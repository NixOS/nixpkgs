{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xprop";
  version = "1.2.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xprop-${finalAttrs.version}.tar.xz";
    hash = "sha256-1onirbfve0OfZGm1HNqKfa78gyQ4VMKjuPhNDwKdZ+4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    xorgproto
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/app/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Command line tool to display and/or set window and font properties of an X server";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xprop";
    license = with lib.licenses; [
      mitOpenGroup
      hpndSellVariant
      mit
    ];
    mainProgram = "xprop";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
