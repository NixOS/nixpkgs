{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wrapWithXFileSearchPathHook,
  xorgproto,
  libx11,
  libxaw,
  libxmu,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xconsole";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xconsole-${finalAttrs.version}.tar.xz";
    hash = "sha256-DHdZeMrN2nbfyLWpcULxRaF30mIg3TB4ZtndYuc5EYk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    xorgproto
    libx11
    libxaw
    libxmu
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

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
    description = "Displays /dev/console messages in an X window";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xconsole";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xconsole";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
