{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxcb,
  libxext,
  libxi,
  libxmu,
  libxrender,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xeyes";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xeyes-${finalAttrs.version}.tar.xz";
    hash = "sha256-VgjXa3sarF7X8i8ba1rXTvmMhpMiDzK0uH3M7kqVbqo=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxcb
    libxext
    libxi
    libxmu
    libxrender
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
    description = "A \"follow the mouse\" X demo, using the X SHAPE extension";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xeyes";
    license = lib.licenses.x11;
    mainProgram = "xeyes";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
