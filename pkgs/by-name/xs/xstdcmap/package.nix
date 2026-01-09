{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxmu,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xstdcmap";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xstdcmap-${finalAttrs.version}.tar.xz";
    hash = "sha256-NlhH43k5hJnsmtmimcxHoNbn/rqVRt/U5bQiIEtawYA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
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
    description = "X standard colormap utility";
    longDescription = ''
      The xstdcmap utility can be used to selectively define standard colormap properties.
      It is intended to be run from a user's X startup script to create standard colormap
      definitions in order to facilitate sharing of scarce colormap resources among clients using
      PseudoColor visuals.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xstdcmap";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xstdcmap";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
