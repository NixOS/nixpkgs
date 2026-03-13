{
  lib,
  stdenv,
  fetchzip,
  gnome-themes-extra,
  gtk2,
  mono,
  makeWrapper,
}:

let
  exePlatformSuffix =
    {
      aarch64-linux = "arm64";
      x86_64-linux = "x64";
      i686-linux = "x86";
      aarch64-darwin = "arm64";
      x86_64-darwin = "x64";
    }
    .${stdenv.hostPlatform.system};

  exe = "XperiFirm-" + exePlatformSuffix + ".exe";
in
stdenv.mkDerivation {
  pname = "xperifirm";
  version = "5.8.1";

  src = fetchzip {
    url = "https://xdaforums.com/attachments/xperifirm-5-8-1-by-igor-eisberg-zip.6286497/";
    extension = "zip";
    stripRoot = false;
    sha256 = "sha256-G/wF2wwEbD6+zt20cIoGtFlYCyie2roDP7TO9FBfUuo=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    mono
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/xperifirm" "$out/etc/gtk-2.0"
    cp "${exe}" "$out/lib/xperifirm"

    # Force GTK2 light theme to avoid dark theme readability issues
    cat >"$out/etc/gtk-2.0/gtkrc" <<'EOF'
    gtk-theme-name = "Adwaita"
    gtk-application-prefer-dark-theme = 0
    EOF

    makeWrapper "${mono}/bin/mono" "$out/bin/XperiFirm" \
      --add-flags "$out/lib/xperifirm/${exe}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk2 ]}" \
      --suffix GTK_PATH : "${gnome-themes-extra}/lib/gtk-2.0" \
      --set GTK2_RC_FILES "$out/etc/gtk-2.0/gtkrc"

    runHook postInstall
  '';

  meta = {
    description = "Allows you to download the current firmware for all Sony Xperia-line smartphones, tablets and accessories released since 2013 (excluding Xperia R1/R1 Plus).";
    homepage = "https://xdaforums.com/t/tool-xperifirm-xperia-firmware-downloader-v5-8-1.2834142/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ toastal ];
    mainProgram = "XperiFirm";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "i686-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
