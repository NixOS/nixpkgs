{
  lib,
  fetchurl,
  stdenvNoCC,
  makeWrapper,
  dpkg,
  asar,
  electron,
}:

stdenvNoCC.mkDerivation {
  pname = "z-library-desktop";
  version = "2.4.3";

  src = fetchurl {
    url = "https://web.archive.org/web/20250725193036/https://s3proxy.cdn-zlib.sk/te_public_files/soft/linux/zlibrary-setup-latest.deb";
    hash = "sha256-OywGJdVUAGxK+C14akbLzhkt/5QE6+lchPHteksOLLY=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    asar
  ];

  buildPhase = ''
    runHook preBuild

    pushd opt/Z-Library/resources
    asar e app.asar app
    rm app.asar
    rm -r app/dist/tor # seems useless
    ln -s dist app/public
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    phome=$out/share/z-library-desktop
    mkdir -p $phome
    cp -r opt/Z-Library/resources $phome

    makeWrapper "${lib.getExe electron}" $out/bin/z-library \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags $phome/resources/app

    cp -r usr/* $out
    substituteInPlace $out/share/applications/z-library.desktop \
      --replace-fail "/opt/Z-Library/z-library" "z-library"

    runHook postInstall
  '';

  passthru.updateScript = ./update.rb;

  meta = {
    homepage = "https://z-library.sk";
    description = "client for the online library Z-Library";
    license = lib.licenses.unfree; # Maintainers on AUR emailed the dev to confirm: https://pastebin.com/ss4Nr8pW
    platforms = electron.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "z-library";
  };
}
