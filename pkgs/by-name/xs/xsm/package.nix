{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wrapWithXFileSearchPathHook,
  xorgproto,
  libice,
  libsm,
  libx11,
  libxaw,
  libxt,
  makeBinaryWrapper,
  writeScript,
  # run time dependencies
  iceauth,
  smproxy,
  twm,
  xterm,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xsm";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xsm-${finalAttrs.version}.tar.xz";
    hash = "sha256-t0zHdMYGDDdZL2ipDb0xsPKmL7FOVidpQ095vihKY84=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wrapWithXFileSearchPathHook
    makeBinaryWrapper
  ];

  buildInputs = [
    xorgproto
    libice
    libsm
    libx11
    libxaw
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  postInstall = ''
    wrapProgram $out/bin/xsm \
      --prefix PATH : ${
        lib.makeBinPath [
          iceauth
          smproxy
          twm
          xterm
        ]
      }
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
    description = "X Session Manager";
    longDescription = ''
      A session is a group of X applications, each of which has a particular state. xsm allows you
      to create arbitrary sessions - for example, you might have a "light" session, a "development"
      session, or an "xterminal" session. Each session can have its own set of applications. Within
      a session, you can perform a "checkpoint" to save application state, or a "shutdown" to save
      state and exit the session. When you log back in to the system, you can load a specific
      session, and you can delete sessions you no longer want to keep.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xsm";
    license = lib.licenses.mitOpenGroup;
    mainProgram = "xsm";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
