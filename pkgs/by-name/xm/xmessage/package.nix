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
  pname = "xmessage";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xmessage-${finalAttrs.version}.tar.xz";
    hash = "sha256-cD/Mt6C3ctYdfmA8GJuXOYZqqXuphccnJ1Qg+CmjA1Y=";
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
    description = "Display a message or query in a window";
    longDescription = ''
      xmessage displays a message or query in a window. The user can click on an "okay" button to
      dismiss it or can select one of several buttons to answer a question. xmessage can also exit
      after a specified time.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xmessage";
    license = lib.licenses.x11;
    mainProgram = "xmessage";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
