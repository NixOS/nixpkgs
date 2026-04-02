{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxmu,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xset";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xset-${finalAttrs.version}.tar.xz";
    hash = "sha256-n2ktVWNbOGLNY2M7EiKodoDsKDx6jo7W3WmKMUf3Xi8=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
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
    description = "User preference utility for X servers";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xset";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xset";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
