{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxaw,
  libxt,
  wrapWithXFileSearchPathHook,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xgc";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xgc-${finalAttrs.version}.tar.xz";
    hash = "sha256-2FgljAXqrC0fSLtEgg3C3OCmhgGhT/+XhTxytI0bfQg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    libxaw
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
    description = "Demo to show various features of the X11 core protocol graphics primitives";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xgc";
    license = with lib.licenses; [
      x11
      mit
    ];
    mainProgram = "xgc";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
