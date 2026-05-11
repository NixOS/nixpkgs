{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  xbitmaps,
  libx11,
  libxcursor,
  libxmu,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xsetroot";
  version = "1.1.3";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xsetroot-${finalAttrs.version}.tar.xz";
    hash = "sha256-YIG0Wp60Qm4EXSWdHhRLMkF/tjXluWqpBkc2WslmONE=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    xbitmaps
    libx11
    libxcursor
    libxmu
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
    description = "Root window parameter setting utility for X";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xsetroot";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xsetroot";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
