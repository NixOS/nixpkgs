{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libxaw,
  libxmu,
  libxt,
  wrapWithXFileSearchPathHook,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "viewres";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/viewres-${finalAttrs.version}.tar.xz";
    hash = "sha256-SyIcKxAzkLFmYzYSuav4A2y76QYF29ijfPKjd/orbNI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    xorgproto
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
    description = "Displays a tree showing the widget class hierarchy of the Athena Widget Set (libxaw)";
    homepage = "https://gitlab.freedesktop.org/xorg/app/viewres";
    license = lib.licenses.x11;
    mainProgram = "viewres";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
