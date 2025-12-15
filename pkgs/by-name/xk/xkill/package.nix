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
  pname = "xkill";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xkill-${finalAttrs.version}.tar.xz";
    hash = "sha256-5aiqeMR1Z3sRUEZG2o2T2swwdEJYB2ospBiiRDiuuQc=";
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
    description = "Utility to forcibly terminate X11 clients";
    longDescription = ''
      xkill is a utility for forcing the X server to close connections to clients.
      This program is very dangerous, but is useful for aborting programs that have displayed
      undesired windows on a user's screen.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xkill";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xkill";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
