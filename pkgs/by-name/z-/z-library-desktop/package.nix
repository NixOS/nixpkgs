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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "z-library-desktop";
  version = "3.1.0";

  src = fetchurl {
    url = "https://web.archive.org/web/20260301212456/https://s3proxy-alp.cdn-zlib.sk/swfs_second_public_files/soft/desktop/Z-Library_3.1.0_amd64.deb";
    hash = "sha256-m1axR0HrqHfoz+1tvhCOr1xq0lVkHjxrrf2KnTA7ZVg=";
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

    makeWrapper ${lib.getExe electron} $out/bin/Z-Library \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags $phome/resources/app \
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
    mainProgram = "Z-Library";
  };
})
