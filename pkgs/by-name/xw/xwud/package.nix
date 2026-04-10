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
  pname = "xwud";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xwud-${finalAttrs.version}.tar.xz";
    hash = "sha256-5Vy+2rNtel9nGr+OWUiIr8SMqhFtUdQp6lPqMX7Axh4=";
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
    description = "Utility to display an image in XWD (X Window Dump) format";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xwud";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xwud";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
