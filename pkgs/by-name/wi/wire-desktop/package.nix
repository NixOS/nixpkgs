{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  electron,
  nodejs,
  yarn-berry_3,
  makeWrapper,
  makeDesktopItem,
  darwin,
  zip,
  jq,
}:
let
  hostPlatform = stdenvNoCC.hostPlatform;
  nodeArch = hostPlatform.node.arch;
  yarn-berry = yarn-berry_3;
  # same hash for this release but can change in the future
  sources = rec {
    x86_64-linux = rec {
      version = "3.40.3882";
      src = fetchFromGitHub {
        owner = "wireapp";
        repo = "wire-desktop";
        tag = "linux/${version}";
        hash = "sha256-pNu+/JKvaKSqHxNeDL8RcDy+FiY3aynQH06t05qgXrA=";
      };
    };
    x86_64-darwin = rec {
      version = "3.40.5442";
      src = fetchFromGitHub {
        owner = "wireapp";
        repo = "wire-desktop";
        tag = "macos/${version}";
        hash = "sha256-pNu+/JKvaKSqHxNeDL8RcDy+FiY3aynQH06t05qgXrA=";
      };
    };
    aarch64-linux = x86_64-linux;
    aarch64-darwin = x86_64-darwin;
  };
  web-config = fetchFromGitHub {
    owner = "wireapp";
    repo = "wire-web-config-wire";
    tag = "v0.34.9-0";
    hash = "sha256-E9x/tRcMfXw/tjgNBUTefym9/m/Xu9/9CclwSmxpDzU=";
  };
  electron-dist-zip = stdenvNoCC.mkDerivation {
    pname = "electron-dist-zip";
    version = electron.version;
    src = electron.dist;
    nativeBuildInputs = [ zip ];
    buildPhase = ''
      zip --recurse-paths - . > $out
    '';
    dontInstall = true;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wire-desktop";
  inherit (sources.${stdenv.system}) version src;

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-md7B8NSqT9dmPxrp9zbWifNow+1j2tuTRMOljG1V8WE=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    jq
    darwin.autoSignDarwinBinariesHook
  ];

  patches = [
    ./build-linux.patch
    ./build-macos.patch
  ];

  # we provide web-config externally due to yarn trying to fetch from github on build phase
  postPatch = ''
    substituteInPlace .copyconfigrc.js \
      --replace-fail 'repositoryUrl,' 'repositoryUrl, externalDir : "${web-config}",'
  '';

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # we put the electrons for each platform under `node_modules/electron-dist` due to electron packager grabbing it otherwise
  buildPhase = ''
    runHook preBuild

    export BUILD_NUMBER=$(echo ${finalAttrs.version} | awk -F. '{print $NF}')
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''

    # this is needed due to macos builder using electron-packager directly
    # we put the zipped electron into a custom path which is defined in the patch, see build-macos.patch
    ELECTRON_VERSION_IN_LOCKFILE=$(yarn why electron --json | tail --lines 1 | jq --raw-output '.children | to_entries | first | .key ' | cut -d : -f 2)
    mkdir node_modules/electron-dist
    cp ${electron-dist-zip} node_modules/electron-dist/electron-v$ELECTRON_VERSION_IN_LOCKFILE-mas-${nodeArch}.zip

    # these variables are needed to skip signing on darwin, we sign with autoSignDarwinBinariesHook later
    export MACOS_CERTIFICATE_NAME_APPLICATION="" MACOS_CERTIFICATE_NAME_INSTALLER=""
    yarn build:macos:${nodeArch}

  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux) ''

    cp -R ${electron.dist} node_modules/electron-dist
    # electron needs to have write access otherwire electron-fuses fails
    chmod -R u+w node_modules/electron-dist

    # we build only for the linux-unpacked output, not other targets
    export LINUX_TARGET=dir
    yarn build:linux

  ''
  + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''

    mkdir -p $out/{Applications,bin}
    cp -r wrap/build/Wire-mas-${nodeArch}/Wire.app $out/Applications

    makeWrapper $out/Applications/Wire.app/Contents/MacOS/Wire $out/bin/wire-desktop

  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux) ''

    mkdir -p $out/share/wire-desktop
    cp -r wrap/dist/linux-unpacked/{locales,resources{,.pak}} $out/share/wire-desktop

    makeWrapper ${lib.getExe electron} $out/bin/wire-desktop \
      --add-flags $out/share/wire-desktop/resources/app.asar \
      --inherit-argv0

    for size in 32 256; do
      install -Dm644 "resources/icons/"$size"x"$size".png" "$out/share/icons/hicolor/"$size"x"$size"/apps/wire-desktop.png"
    done

  ''
  + ''
    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
      "VideoConference"
    ];
    comment = "Secure messenger for everyone";
    desktopName = "Wire";
    exec = "wire-desktop %U";
    genericName = "Secure messenger";
    icon = "wire-desktop";
    name = "wire-desktop";
    startupWMClass = "Wire";
  };

  meta = {
    description = "Modern, secure messenger for everyone";
    longDescription = ''
      Wire Personal is a secure, privacy-friendly messenger. It combines useful
      and fun features, audited security, and a beautiful, distinct user
      interface.  It does not require a phone number to register and chat.

        * End-to-end encrypted chats, calls, and files
        * Crystal clear voice and video calling
        * File and screen sharing
        * Timed messages and chats
        * Synced across your phone, desktop and tablet
    '';
    homepage = "https://wire.com/";
    downloadPage = "https://wire.com/download/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      arianvp
      ern775
      korkutkardes7
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
