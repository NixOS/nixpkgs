{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libx11,
  libxcb,
  xorgproto,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xwininfo";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xwininfo-${finalAttrs.version}.tar.xz";
    hash = "sha256-NRiJfBdEjfm6ma1tm7HKDxe8DtfA/WEoGzTO7SmpJT8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxcb
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
    description = "Utility to print information about windows on an X server";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xwininfo";
    license = with lib.licenses; [
      mit
      # mit-open-group with icu disclaimer ?!
      # close enough to mit-open-group
      mitOpenGroup
      hpndSellVariant
    ];
    mainProgram = "xwininfo";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
