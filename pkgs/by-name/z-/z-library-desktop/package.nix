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

let
  # adapted from element-desktop.passthru.keytar
  keytar = buildNpmPackage (finalAttrs: {
    pname = "keytar";
    version = "7.9.0";

    src = fetchFromGitHub {
      owner = "atom";
      repo = "node-keytar";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Mnl0Im2hZJXJEtyXb5rgMntekkUAnOG2MN1bwfgh0eg=";
    };

    nativeBuildInputs = [
      pkg-config
      removeReferencesTo
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin xcbuild;

    postHook = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      pkg-config() { "''${PKG_CONFIG}" "$@"; }
      export -f pkg-config
    '';

    npmDepsHash = "sha256-ldfRWV+HXBdBYO2ZiGbVFSHV4/bMG43U7w+sJ4kpVUY=";

    buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libsecret ];
    npmFlags = [
      "--nodedir=${electron.headers}"
      "--arch=${stdenv.hostPlatform.node.arch}"
    ];

    doCheck = false;

    postInstall = ''
      rm -rf $out/lib/node_modules/keytar/{node_modules,src,*.gyp}
      install -D -t $out/lib/node_modules/keytar/build/Release build/Release/keytar.node
      remove-references-to -t ${stdenv.cc.cc} $out/lib/node_modules/keytar/build/Release/keytar.node
    '';

    meta.license = lib.licenses.mit;
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "z-library-desktop";
  version = "3.0.0";

  src = fetchurl {
    url = "https://web.archive.org/web/20250922072315/https://s3proxy.cdn-zlib.sk/te_public_files/soft/desktop/Z-Library_3.0.0_amd64.deb";
    hash = "sha256-ysxlf0d6HOBq9Ho8Tj1P1xROwUZ/tLdI1PRSUTV3jMY=";
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

    rm -rf $phome/resources/app/node_modules/keytar
    ln -s ${keytar}/lib/node_modules/keytar $phome/resources/app/node_modules/keytar

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

  passthru = {
    inherit keytar;
    updateScript = ./update.rb;
  };

  meta = {
    homepage = "https://z-library.sk";
    description = "client for the online library Z-Library";
    license = lib.licenses.unfree; # Maintainers on AUR emailed the dev to confirm: https://pastebin.com/ss4Nr8pW
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "Z-Library";
  };
})
