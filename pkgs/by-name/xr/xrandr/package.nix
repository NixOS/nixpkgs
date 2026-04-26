{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxrandr,
  libxrender,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xrandr";
  version = "1.5.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xrandr-${finalAttrs.version}.tar.xz";
    hash = "sha256-LK/MsqrySRpAaGdhF6DU+QqzB3JLlv/8VM0dqVN3lAA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxrandr
    libxrender
  ];

  postInstall = ''
    # remove useless xkeystone script
    # it is written in a language not packaged in nixpkgs
    rm $out/bin/xkeystone
  '';

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
    description = "Command line interface to X11 Resize, Rotate, and Reflect (RandR) extension";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xrandr";
    license = lib.licenses.hpndSellVariant;
    mainProgram = "xrandr";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
