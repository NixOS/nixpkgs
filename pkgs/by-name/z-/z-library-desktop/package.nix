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

  installPhase = ''
    runHook preInstall

    phome=$out/lib/z-library-desktop
    mkdir -p $phome
    cp -r opt/Z-Library/resources $phome
    pushd $phome/resources
    asar e app.asar app
    rm app.asar
    rm -r app/dist/tor # seems useless
    ln -s dist app/public
    popd

    makeWrapper "${lib.getExe electron}" $out/bin/z-library \
      --add-flags $phome/resources/app

    cp -r usr/* $out
    sed -i 's/^Exec=.*/Exec=z-library %U/g' $out/share/applications/z-library.desktop

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
