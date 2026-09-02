{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libGL,
  xorgproto,
  libx11,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdriinfo";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xdriinfo-${finalAttrs.version}.tar.xz";
    hash = "sha256-AEYwVkNbgiYcInrQ3hhz/UU2EBYH+8V1QOKOSgqbcfc=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libGL
    xorgproto
    libx11
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
    description = "Utility to query configuration information of X11 DRI drivers";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xdriinfo";
    license = lib.licenses.mit;
    mainProgram = "xdriinfo";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
