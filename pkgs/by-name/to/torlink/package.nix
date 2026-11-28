{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  cmake,
  nodejs,
  libdatachannel,
  openssl,
  plog,
  wl-clipboard,
  xclip,
  versionCheckHook,
  nix-update-script,
}:

let
  # Headers only. cmake-js would supply them, but node-datachannel's lockfile
  # is out of sync with its package.json, so `npm ci` cannot install it.
  nodeAddonApi = fetchFromGitHub {
    owner = "nodejs";
    repo = "node-addon-api";
    tag = "v8.9.0";
    hash = "sha256-1tOPwH7AmbwQVvhuyIb2TmZrsNJTTvE+giRXvEtaD6g=";
  };

  # WebRTC addon, built against libdatachannel from nixpkgs in place of the
  # prebuilt binaries npm installs. Must match the node-datachannel version in
  # torlink's package-lock.json; postInstall checks it.
  nodeDatachannel = stdenv.mkDerivation (finalAttrs: {
    pname = "node-datachannel";
    version = "0.33.1";

    src = fetchFromGitHub {
      owner = "murat-dogan";
      repo = "node-datachannel";
      tag = "v${finalAttrs.version}";
      hash = "sha256-caLkYIR51RgEvpXVczz/aGwG3QyRjqHMjhjKLADHgd0=";
    };

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [ cmake ];

    buildInputs = [
      libdatachannel
      openssl
      plog
    ];

    # Link the shared libdatachannel instead of a static copy fetched by CMake.
    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'OPENSSL_USE_STATIC_LIBS TRUE' 'OPENSSL_USE_STATIC_LIBS FALSE' \
        --replace-fail 'if(NOT libdatachannel)' 'if(false)' \
        --replace-fail 'datachannel-static' 'datachannel' \
        --replace-fail 'plog::plog' "" \
        --replace-fail 'list(APPEND LINK_LIBRARIES -static-libgcc -static-libstdc++)' ""
    '';

    cmakeFlags = [
      (lib.cmakeFeature "CMAKE_JS_INC" "${lib.getDev nodejs}/include/node;${nodeAddonApi}")
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 node_datachannel.node -t $out/build/Release

      runHook postInstall
    '';
  });
in
buildNpmPackage (finalAttrs: {
  pname = "torlink";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "baairon";
    repo = "torlink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bSdjiVpZJSVIicz4CT7a4mNj4xR42J8mfwXAd/9+zAA=";
  };

  npmDepsHash = "sha256-UpvVXnMeeYTKzg1GHdN1TLnd9SS5CMEtVmpDAKSkMvk=";

  # The install scripts call npx, which needs the network.
  npmFlags = [ "--ignore-scripts" ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  # Skipped along with the other scripts; it creates dist/cli.cjs, the bin entry.
  postBuild = ''
    node scripts/postbuild.cjs
  '';

  postInstall = ''
    modules=$out/lib/node_modules/torlnk/node_modules

    locked=$(node -p "require('$modules/node-datachannel/package.json').version")
    if [[ $locked != ${nodeDatachannel.version} ]]; then
      echo "package-lock.json has node-datachannel $locked, nodeDatachannel is ${nodeDatachannel.version}" >&2
      exit 1
    fi

    # Remove the prebuilt addons so that only the one built above can be loaded.
    rm -r $modules/@node-datachannel $modules/node-datachannel/npm-artifacts
    ln -s ${nodeDatachannel}/build $modules/node-datachannel/build
  '';

  makeWrapperArgs = [
    # Clipboard support shells out to wl-copy, wl-paste and xclip.
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      wl-clipboard
      xclip
    ])
    # Updates come from nixpkgs, so skip the npm registry lookup.
    "--set-default"
    "TORLINK_NO_UPDATE_CHECK"
    "1"
  ];

  doInstallCheck = true;

  # torlnk falls back to a stub when the addon cannot be loaded, so the version
  # check alone would not notice a broken build.
  postInstallCheck = ''
    node -e '
      const { PeerConnection, getLibraryVersion } = require(process.argv[1]);
      if (typeof PeerConnection !== "function") process.exit(1);
      console.log("node-datachannel loaded with libdatachannel", getLibraryVersion());
    ' $out/lib/node_modules/torlnk/node_modules/node-datachannel
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Zero-setup torrent finder and downloader that lives right in your terminal";
    homepage = "https://torlink.bairon.dev";
    changelog = "https://github.com/baairon/torlink/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      baairon
      ghastrum
    ];
    mainProgram = "torlnk";
    platforms = lib.platforms.linux;
    # Optional addons of webtorrent ship as prebuilt binaries in their npm tarballs.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
