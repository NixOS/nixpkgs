{
  lib,
  stdenv,
  cacert,
  buildFHSEnv,
  fetchurl,
  dpkg,
}:

let
  version = "0.1.804-beta";

  unsloth-desktop-unwrapped = stdenv.mkDerivation {
    pname = "unsloth-desktop-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://github.com/unslothai/unsloth/releases/download/v${version}/Unsloth-Desktop-Ubuntu.deb";
      hash = "sha256-DrHbR7pGeTtvlPIDZD0SPO6pUf792Rskd1x1ANMmpfw=";
    };

    nativeBuildInputs = [ dpkg ];

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;

    installPhase = ''
      runHook preInstall
      dpkg-deb -x $src $out
      runHook postInstall
    '';

    meta = {
      description = "Unsloth Studio desktop payload from the upstream .deb (unwrapped)";
      homepage = "https://unsloth.ai/";
      license = lib.licenses.agpl3Only;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };
in
buildFHSEnv {
  pname = "unsloth-desktop";
  inherit version;

  includeClosures = true;

  targetPkgs =
    pkgs: with pkgs; [
      webkitgtk_4_1
      gtk3
      libsoup_3
      glib-networking
      gsettings-desktop-schemas
      hicolor-icon-theme
      shared-mime-info
      libayatana-appindicator
      libnghttp2
      nodejs_24
      cacert
    ];

  profile = ''
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
  '';

  runScript = "${unsloth-desktop-unwrapped}/usr/bin/unsloth-studio";

  extraInstallCommands = ''
    install -Dm644 ${unsloth-desktop-unwrapped}/usr/share/applications/Unsloth.desktop \
      $out/share/applications/unsloth-desktop.desktop
    substituteInPlace $out/share/applications/unsloth-desktop.desktop \
      --replace-fail "Exec=unsloth-studio" "Exec=unsloth-desktop"
    install -Dm644 ${unsloth-desktop-unwrapped}/usr/share/icons/hicolor/128x128/apps/unsloth-studio.png \
      $out/share/icons/hicolor/128x128/apps/unsloth-studio.png
  '';

  passthru = { inherit unsloth-desktop-unwrapped; };

  meta = {
    description = "Desktop application for running and training AI models locally";
    homepage = "https://unsloth.ai/";
    changelog = "https://github.com/unslothai/unsloth/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ parry-97 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "unsloth-desktop";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    longDescription = ''
      Wraps the upstream Unsloth Desktop .deb in an FHS environment.

      The app manages its own runtime in ~/.unsloth/studio: on first run it
      bootstraps a uv venv, installs the unsloth PyPI backend and PyTorch
      (CUDA wheels selected by GPU), and downloads prebuilt llama.cpp binaries.
      These runtime components are not part of this package.

      Note: the in-app self-updater cannot replace the read-only store binary;
      update by rebuilding this package.
    '';
  };
}
