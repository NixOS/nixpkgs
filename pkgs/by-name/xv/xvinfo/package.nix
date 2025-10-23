{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxv,
  libxext,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xvinfo";
  version = "1.1.5";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xvinfo-${finalAttrs.version}.tar.xz";
    hash = "sha256-Pt5x7LJtlhTMvGkWcgKF6VosfgxeGbhXDqr3KtfFxAQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxv
    libxext
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
    description = "Utility to print out X-Video extension adaptor information";
    longDescription = ''
      xvinfo prints out the capabilities of any video adaptors associated with the display that are
      accessible through the X-Video extension.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xvinfo";
    license = lib.licenses.x11;
    mainProgram = "xvinfo";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
