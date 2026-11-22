{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  makeBinaryWrapper,
  replaceVars,
  dpkg,
  asar,
  electron,
  darwin,
  libsecret,
  pkg-config,
  buildNpmPackage,
  removeReferencesTo,
  xcbuild,
  tor,
  xray,
  obfs4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "z-library-desktop";
  version = "3.2.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20260927191559/https://dln1.ncdn.ec/general-files/soft/desktop/Z-Library_3.2.1_amd64.deb";
    hash = "sha256-1zmcFIoZWuKUgS4YhyYrsIYISEFD1diEqtNbZvs4lC4=";
  };

  nativeBuildInputs = [
    dpkg
    makeBinaryWrapper
    asar
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin darwin.autoSignDarwinBinariesHook;

  buildPhase = ''
    runHook preBuild

    pushd opt/Z-Library/resources
    asar e app.asar app
    rm app.asar
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    phome=$out/opt/Z-Library
    mkdir -p $phome/resources
    cp -r opt/Z-Library/resources/app $phome/resources
    app=$phome/resources/app

    rm -rf $app/dist-electron/{configs,tor,xray}

    # Looks for bundled binaries under process.resourcesPath,
    # which is not correct if we are not using upstream bundled Electron.
    substituteInPlace $app/dist-electron/main.js \
      --replace-fail 'path.join(process.resourcesPath, "proxies"' \
      'path.join(app.getAppPath(), "proxies"' \
      --replace-fail 'LD_PRELOAD: path.join(dirname, "./linux-64/libevent-2.1.so.7"),' \
      '...process.env,'

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      # Supports tor and xray on linux only, where binaries are searched in fixed dirs.
      # Use shipped config files and nixpkgs packaged binaries.
      mkdir -p $app/proxies/{torProxy/{configs,linux-64/pluggable_transports},xray-proxy/xray/linux-64}
      cp {opt/Z-Library/resources,$app}/proxies/torProxy/configs/torrc_template
      cp -r {opt/Z-Library/resources,$app}/proxies/xray-proxy/xray/configs
      ln -s ${lib.getExe tor} $app/proxies/torProxy/linux-64/tor
      ln -s ${lib.getExe obfs4} $app/proxies/torProxy/linux-64/pluggable_transports/lyrebird
      ln -s ${lib.getExe xray} $app/proxies/xray-proxy/xray/linux-64/xray
    ''}

    makeWrapper ${lib.getExe electron} $out/bin/Z-Library \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags $app \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    cp -r usr/* $out
    substituteInPlace $out/share/applications/Z-Library.desktop \
      --replace-fail "/opt/Z-Library/Z-Library" "Z-Library"

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications/Z-Library.app/Contents/{MacOS,Resources}
    ln -s $out/bin/z-library $out/Applications/Z-Library.app/Contents/MacOS/Z-Library
    ln -s $phome/resources/app/dist/icon.icns $out/Applications/Z-Library.app/Contents/Resources/icon.icns
    install -Dm444 ${
      # Adapted from the dmg package from upstream.
      # Note that the upstream distributed version for macOS is actually older than those for other systems,
      # but here we packaged it for macOS using the deb package, so it has the same version as the Linux version.
      replaceVars ./Info.plist { inherit (finalAttrs) version; }
    } $out/Applications/Z-Library.app/Contents/Info.plist
  '';

  passthru.updateScript = ./update.rb;

  meta = {
    homepage = "https://z-library.sk";
    description = "Client for the online library Z-Library";
    license = lib.licenses.unfree; # Maintainers on AUR emailed the dev to confirm: https://pastebin.com/ss4Nr8pW
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    sourceProvenance = with lib.sourceTypes; [ obfuscatedCode ];
    mainProgram = "Z-Library";
  };
})
