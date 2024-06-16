{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, rustc
, wasm-pack
, wasm-bindgen-cli
, binaryen

, fetchYarnDeps
, yarn
, fixup_yarn_lock
, nodejs
, asar

, tetrio-src
, tetrio-version
}:

let
  version = "0.27.2";

  src = fetchFromGitLab {
    owner = "UniQMG";
    repo = "tetrio-plus";
    rev = "electron-v${version}-tetrio-v${lib.versions.major tetrio-version}";
    hash = "sha256-PvTivTt1Zuvk5gaCcQDcIBFsUf/ZG7TJYXqm0NP++Bw=";
    fetchSubmodules = true;

    # tetrio-plus uses this info for displaying its version,
    # so we need to deep clone to have all the revision history.
    # After we're done, we emulate 'leaveDotGit = false' by removing
    # all the .git folders.
    leaveDotGit = true;
    deepClone = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD~1 > resources/ci-commit-previous
      git rev-parse --short HEAD > resources/ci-commit
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  wasm-bindgen-82 = wasm-bindgen-cli.override {
    version = "0.2.82";
    hash = "sha256-BQ8v3rCLUvyCCdxo5U+NHh30l9Jwvk9Sz8YQv6fa0SU=";
    cargoHash = "sha256-mP85+qi2KA0GieaBzbrQOBqYxBZNRJipvd2brCRGyOM=";
  };

  tpsecore = rustPlatform.buildRustPackage {
    pname = "tpsecore";
    inherit version src;

    sourceRoot = "${src.name}/tpsecore";

    cargoHash = "sha256-K9l8wQOtjf3l8gZMMdVnaNrgzVWGl62iBBcpA+ulJbw=";

    nativeBuildInputs = [
      wasm-pack
      wasm-bindgen-82
      binaryen
      rustc.llvmPackages.lld
    ];

    buildPhase = ''
      HOME=$(mktemp -d) wasm-pack build --target web --release
    '';

    installPhase = ''
      cp -r pkg/ $out
    '';

    doCheck = false;

    meta = {
      description = "A self contained toolkit for creating, editing, and previewing TPSE files";
      homepage = "https://gitlab.com/UniQMG/tpsecore";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ huantian wackbyte ];
      platforms = lib.platforms.linux;
      # See comment about wasm32-unknown-unknown in rustc.nix.
      broken = lib.any (a: lib.hasAttr a stdenv.hostPlatform.gcc) [ "cpu" "float-abi" "fpu" ] ||
        !stdenv.hostPlatform.gcc.thumb or true;
    };
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/resources/desktop-ci/yarn.lock";
    hash = "sha256-LfUC2bkUX+sFq3vMMOC1YVYbpDxUSnLO9GiKdoQBdAw=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "tetrio-plus";
  inherit version src;

  nativeBuildInputs = [
    yarn
    fixup_yarn_lock
    nodejs
    asar
  ];

  buildPhase = ''
    runHook preBuild

    # 'out' is the directory that the tetrio-plus expects the vanilla asar to be
    # and this is the directory that will contain the final result that we want
    asar extract ${tetrio-src}/opt/TETR.IO/resources/app.asar out
    cd out

    # Install custom package.json/yarn.lock that describe the additional node
    # dependencies that tetrio-plus needs to run, and install them in our output
    cp ../resources/desktop-ci/yarn.lock .
    patch package.json ../resources/desktop-ci/package.json.diff

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror ${offlineCache}
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    cd ..

    # The simple build script expects the vanilla asar located here
    # This patches the vanilla code to load the tetrio-plus code
    ln -s ${tetrio-src}/opt/TETR.IO/resources/app.asar app.asar
    node ./scripts/build-electron.js

    # Finally, we install the tetrio-plus code where the above patch script expects
    cp -r $src out/tetrioplus
    chmod -R u+w out/tetrioplus

    # Disable the uninstall button in the tetrio-plus popup,
    # as it doesn't make sense to mutably uninstall it in a nix package
    substituteInPlace out/tetrioplus/desktop-manifest.js \
      --replace-fail '"show_uninstaller_button": true' '"show_uninstaller_button": false'

    # We don't need the tpsecore source code bundled
    rm -rf out/tetrioplus/tpsecore/
    # since we install the compiled version here
    cp ${tpsecore}/{tpsecore_bg.wasm,tpsecore.js} out/tetrioplus/source/lib/

    runHook postBuild
  '';

  installPhase = ''
    runHook preinstall

    mkdir -p $out
    asar pack out $out/app.asar

    runHook postinstall
  '';

  meta = {
    description = "TETR.IO customization tool suite";
    downloadPage = "https://gitlab.com/UniQMG/tetrio-plus/-/releases";
    homepage = "https://gitlab.com/UniQMG/tetrio-plus";
    license = [
      lib.licenses.mit
      # while tetrio-plus is itself mit, the result of this derivation
      # is a modified version of tetrio-desktop, which is unfree.
      lib.licenses.unfree
    ];
    maintainers = with lib.maintainers; [ huantian wackbyte ];
    platforms = lib.platforms.linux;
  };
})
