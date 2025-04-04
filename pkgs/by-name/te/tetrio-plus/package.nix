{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
  asar,

  tpsecore,
  tetrio-desktop,
}:

let
  version = "0.27.5";
  tag = "electron-v${version}-tetrio-v${tetrio-desktop.version}";

  src = fetchFromGitLab {
    owner = "UniQMG";
    repo = "tetrio-plus";
    inherit tag;
    hash = "sha256-hbHofrC2dJOh2kh3VLb/d0dHrcszyqTyID1PAaGApxY=";
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
    fixup-yarn-lock
    nodejs
    asar
  ];

  buildPhase = ''
    runHook preBuild

    # tetrio-plus expects the vanilla asar to be extracted into 'out' and
    # 'out' is the directory containing the final patched asar's contents
    asar extract ${tetrio-desktop.src}/opt/TETR.IO/resources/app.asar out

    # Install custom package.json/yarn.lock that describe the additional node
    # dependencies that tetrio-plus needs to run, and install them in our output
    cd out

    cp ../resources/desktop-ci/yarn.lock .
    patch package.json ../resources/desktop-ci/package.json.diff

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror ${offlineCache}
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    cd ..

    # The included build script expects the vanilla asar located here
    # This patches the vanilla code to load the tetrio-plus code
    ln -s ${tetrio-desktop.src}/opt/TETR.IO/resources/app.asar app.asar
    node ./scripts/build-electron.js

    # Actually install tetrio-plus where the above patch script expects
    cp -r $src out/tetrioplus
    chmod -R u+w out/tetrioplus
    # Install tpsecore
    cp ${tpsecore}/{tpsecore_bg.wasm,tpsecore.js} out/tetrioplus/source/lib/

    # Disable useless uninstall button in the tetrio-plus popup
    substituteInPlace out/tetrioplus/desktop-manifest.js \
      --replace-fail '"show_uninstaller_button": true' '"show_uninstaller_button": false'
    # Display 'nixpkgs' next to version in tetrio-plus popup
    echo "nixpkgs" > out/tetrioplus/resources/override-commit

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    asar pack out $out

    runHook postInstall
  '';

  meta = {
    description = "Modified TETR.IO desktop app.asar with many customization tools";
    longDescription = ''
      To use this, `override` the `withTetrioPlus` attribute of `tetrio-desktop`.
    '';
    homepage = "https://gitlab.com/UniQMG/tetrio-plus";
    downloadPage = "https://gitlab.com/UniQMG/tetrio-plus/-/releases";
    changelog = "https://gitlab.com/UniQMG/tetrio-plus/-/releases/${tag}";
    license = [
      lib.licenses.mit
      # while tetrio-plus is itself mit, the result of this derivation
      # is a modified version of tetrio-desktop, which is unfree.
      lib.licenses.unfree
    ];
    maintainers = with lib.maintainers; [
      huantian
      wackbyte
    ];
    platforms = lib.platforms.linux;
  };
})
