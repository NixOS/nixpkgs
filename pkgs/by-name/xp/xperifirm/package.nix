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
  inherit (stdenv) hostPlatform;

  exePlatformSuffix =
    if hostPlatform.isx86_64 then
      "x64"
    else if hostPlatform.isAarch64 then
      "arm64"
    else if hostPlatform.isx86_32 then
      "x86"
    else
      throw "Unsupported platform: ${hostPlatform.system}";

  exe = "XperiFirm-" + exePlatformSuffix + ".exe";
in
stdenv.mkDerivation {
  pname = "xperifirm";
  version = "5.8.1";

  src = fetchzip {
    url = "https://xdaforums.com/attachments/xperifirm-5-8-1-by-igor-eisberg-zip.6286497/";
    extension = "zip";
    stripRoot = false;
    hash = "sha256-G/wF2wwEbD6+zt20cIoGtFlYCyie2roDP7TO9FBfUuo=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/xperifirm" "$out/share/xperifirm/gtk-2.0"
    cp "${exe}" "$out/lib/xperifirm"

    # Force GTK2 light theme to avoid dark theme readability issues
    cat >"$out/share/xperifirm/gtk-2.0/gtkrc" <<'EOF'
    gtk-theme-name = "Adwaita"
    gtk-application-prefer-dark-theme = 0
    EOF

    makeWrapper "${lib.getExe mono}" "$out/bin/XperiFirm" \
      --add-flags "$out/lib/xperifirm/${exe}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gtk2 ]}" \
      --suffix GTK_PATH : "${gnome-themes-extra}/lib/gtk-2.0" \
      --set GTK2_RC_FILES "$out/share/xperifirm/gtk-2.0/gtkrc"

    runHook postInstall
  '';

  meta = {
    description = "Allows you to download the current firmware for all Sony Xperia-line smartphones, tablets and accessories released since 2013 (excluding Xperia R1/R1 Plus)";
    homepage = "https://xdaforums.com/t/tool-xperifirm-xperia-firmware-downloader-v5-8-1.2834142/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ toastal ];
    mainProgram = "XperiFirm";
    platforms =
      let
        # Mono can run on many platforms, but the executables are only built
        # for these architectures. As Mono platform support expands, so too can
        # this list.
        supportedArches = [
          "x86_64"
          "x86_32"
          "aarch64"
        ];
        supportedPlatform = platform: lib.any (arch: lib.hasPrefix arch platform) supportedArches;
      in
      lib.filter supportedPlatform mono.meta.platforms;
  };
}
