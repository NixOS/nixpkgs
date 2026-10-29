{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  xorgproto,
  libx11,
  libxau,
  libxmu,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xhost";
  version = "1.0.10";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xhost-${finalAttrs.version}.tar.xz";
    hash = "sha256-qK/XAFlHnHEpSLiV5Bw1pKi/zt47otWkuFXIi7tyW+E=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    xorgproto
    libx11
    libxau
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
    description = "X server access control program";
    longDescription = ''
      xhost is used to manage the list of host names or user names allowed to make connections to
      the X server.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xhost";
    license = with lib.licenses; [
      mit
      icu
    ];
    mainProgram = "xhost";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
