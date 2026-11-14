{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScriptBin,
  curl,
  libGL,
  libx11,
  raylib,
}:
let
  tlescope = stdenv.mkDerivation (finalAttrs: {
    pname = "tlescope";
    version = "3.9.3";

    src = fetchFromGitHub {
      owner = "aweeri";
      repo = "TLEscope";
      tag = "v${finalAttrs.version}";
      hash = "sha256-3TmOuiL/57u5+to5CQN5+fjDozfAFvFgeymeiMtaDGc=";
    };

    patches = [
      ./raylib.patch
    ];

    postPatch = ''
      substituteInPlace Makefile --replace-fail "GIT_VERSION := " "GIT_VERSION := v${finalAttrs.version}#"
    '';

    buildInputs = [
      curl
      libGL
      libx11
      raylib
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/TLEscope
      cp -r dist/TLEscope-Linux-Portable/* $out/opt/TLEscope/
      chmod 755 $out/opt/TLEscope/TLEscope

      runHook postInstall
    '';
  });
in
(writeShellScriptBin "TLEscope" ''
  # https://github.com/aweeri/TLEscope/blob/v3.9.3/Makefile#L151

  USER_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/TLEscope"
  INSTALL_DIR="${tlescope}/opt/TLEscope"

  mkdir -p "$USER_DIR"

  ln -sfn "$INSTALL_DIR/themes" "$USER_DIR/themes"
  ln -sfn "$INSTALL_DIR/logo.png" "$USER_DIR/logo.png"

  cd "$USER_DIR"
  exec "$INSTALL_DIR/TLEscope" "$@"
'').overrideAttrs
  (_: {
    strictDeps = true;
    __structuredAttrs = true;

    meta = {
      description = "Modern and interactive 3D/2D satellite position tracker based on real TLE data";
      homepage = "https://tlescope.eu";
      platforms = lib.platforms.linux;
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ noderyos ];
    };
  })
