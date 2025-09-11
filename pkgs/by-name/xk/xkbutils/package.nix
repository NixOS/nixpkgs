{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxaw,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xkbutils";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xkbutils-${finalAttrs.version}.tar.xz";
    hash = "sha256-MaK77h4JzLoB3pKJe49UC1Rd6BLzGNMd4HvTpade4l4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxaw
    libxt
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
    description = "Collection of small XKB utilities";
    longDescription = ''
      xkbutils is a collection of small utilities using the X Keyboard extenison:
      - xkbbell: generate X Keyboard Extension bell events
      - xkbvleds: display X Keyboard Extension LED state in a window
      - xkbwatch: report state changes using the X Keyboard Extension
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xkbutils";
    license = with lib.licenses; [
      hpnd
      hpndDec
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
