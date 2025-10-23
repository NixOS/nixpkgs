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
  pname = "xmodmap";
  version = "1.0.11";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xmodmap-${finalAttrs.version}.tar.xz";
    hash = "sha256-mi+BaPewvDgoKIR0A5Astr8XXhdlizYYnqyH7dqHfoE=";
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
    description = "Utility for modifying keymaps and pointer button mappings in X";
    longDescription = ''
      The xmodmap program is used to edit and display the keyboard modifier map and keymap table
      that are used by client applications to convert event keycodes into keysyms. It is usually run
      from the user's session startup script to configure the keyboard according to personal tastes.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xmodmap";
    license = with lib.licenses; [
      mit
      mitOpenGroup
    ];
    mainProgram = "xmodmap";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
