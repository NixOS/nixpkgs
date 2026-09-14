{
  stdenvNoCC,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  writableTmpDirAsHomeHook,
  makeWrapper,
  electron,
  nodejs,
  zip,
  makeDesktopItem,
  copyDesktopItems,
  lib,
  nix-update-script,
  withDebug ? false,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "webeep-sync";
  version = "1.0.3-unstable-2026-03-24";

  src = fetchFromGitHub {
    owner = "toto04";
    repo = "webeep-sync";
    rev = "eabae4471b32660358c8bf95a985473f145d160a";
    hash = "sha256-wQUNhuhuARLJG0ZYRVpIAgUIbYDFTLC3sRH762HOmBY=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10
    writableTmpDirAsHomeHook
    makeWrapper
    nodejs
    zip
    electron
    copyDesktopItems
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-IuI1asHqq2n1/hqf1NlRUG5/GU7HTLKCjalNooyPcO4=";
    pnpm = pnpm_10;
    fetcherVersion = 3;
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  patches = [ ./workspace.patch ]; # TODO: waiting for PR https://github.com/toto04/webeep-sync/pull/138

  preBuild = ''
    # create the electron archive to be used by electron-packager
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    # force @electron/packager to use our electron instead of downloading it
    substituteInPlace node_modules/.pnpm/@electron+packager@*/node_modules/@electron/packager/dist/packager.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "'$(pwd)/electron.zip'"
  '';

  buildPhase = ''
    runHook preBuild
    pnpm config set node-linker hoisted
    pnpm run package | cat
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString (!withDebug) ''
      find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    ''}

    rm -rf node_modules/.pnpm/{*electron*,*typescript*,prettier*,eslint*,@babel*,react-icons*}
    # remove symlinks to the previously deleted packages
    find node_modules packages/**/node_modules -xtype l -delete

    mkdir -p $out/lib/node_modules/${finalAttrs.pname}
    cp -r .webpack node_modules $out/lib/node_modules/${finalAttrs.pname}/

    makeWrapper ${electron}/bin/electron $out/bin/${finalAttrs.pname} \
      ${lib.optionalString withDebug ''--set NODE_OPTIONS "--enable-source-maps"''} \
      --add-flags "$out/lib/node_modules/${finalAttrs.pname}/.webpack/x64/main/index.js" \
      --add-flags "--user-data-dir=\$HOME/.config/${finalAttrs.pname}"

    for size in 32 48 64 72 96 128 256; do
      install -Dm644 static/icons/icon-$size"x"$size.png \
        $out/share/icons/hicolor/$size"x"$size/apps/${finalAttrs.pname}.png
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.pname;
      icon = finalAttrs.pname; # Matches the PNG name we installed earlier
      desktopName = "WeBeep Sync";
      comment = finalAttrs.meta.description;
      categories = [ "Education" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keep all your WeBeep files synced on your computer";
    homepage = "https://github.com/toto04/webeep-sync";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.lnk3 ];
    mainProgram = "webeep-sync";
  };
})
