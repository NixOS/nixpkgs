{
  lib,
  buildNpmPackage,
  importNpmLock,
  fetchFromGitHub,
  writeShellScript,

  buildWebsocketServer ? false,
  nodejs,
  node ? nodejs,

  buildElectronApp ? true,
  makeWrapper,
  electron_40,
  electron ? electron_40,

  # When using the package directly, must override these settings for frontend
  settings ? {
    # Required for sharing the board to others
    # If not set, service will work as long as we don't use the share feature
    server = {
      websocket = "";
      frontend = "";
    };
  },
  socketAddr ? {
    port = 8080;
  },
}:
let
  src = fetchFromGitHub {
    owner = "tableaunoir";
    repo = "tableaunoir";
    rev = "a4f6a9aa884e387e79d39250a0bc28b35e26a091";
    sha256 = "sha256-2CmeOhXQiysae6rZfiKS2pUekJcfO0uS+ABwTc+/LOY=";
  };
  version = "27-02-26";

  tableaunoir-ws-start = writeShellScript "tableaunoir-ws-start.sh" ''
    cd $(dirname $0)
    ${lib.getExe node} ./main.js
  '';

  wsbackend = buildNpmPackage {
    pname = "tableaunoir-ws";
    inherit version;
    src = "${src}/server";
    npmDepsHash = "sha256-TyCyrvJ/GbSPSlY2nvINe2w91u2D15Yej7aN9G4Er7c=";
    dontBuild = true;
    NODE_ENV = "production";
    postPatch = ''
      sed -i 's+{ port: 8080 }+${builtins.toJSON socketAddr}+g' main.js
      cp ${./package-lock.json} ./package-lock.json
    '';
    installPhase = ''
      mkdir -p $out/
      cp -r node_modules package*.json main.js $out/
      cp ${tableaunoir-ws-start} $out/tableaunoir-ws
    '';
  };

  installWebsocketServer =
    if !buildWebsocketServer then
      ""
    else
      ''
        ln -s ${wsbackend} $out/ws-server
      '';

  installElectron =
    if !buildElectronApp then
      ""
    else
      ''
        cp mainElectron.js $out/frontend/
        sed -i "s+dist/index.html+$out/frontend/index.html+g" $out/frontend/mainElectron.js
        makeWrapper '${electron}/bin/electron' "$out/bin/tableaunoir" \
          --add-flags "$out/frontend/mainElectron.js"
      '';
in
buildNpmPackage {
  pname = "tableaunoir";
  inherit version src;
  npmDepsHash = "sha256-JbNVHtfxmKMpHtLPV4AQyqnwvhR9Zmal6SjIrVDaQ7o=";
  postPatch = ''
    cat << 'EOF' > ./src/config.json
    ${builtins.toJSON settings}
    EOF
  '';

  nativeBuildInputs = if buildElectronApp then [ makeWrapper ] else [ ];
  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  preBuild = ''
    # Requires to fetch dev dependencies as well, in order to build in production later
    export NODE_ENV="production"
  '';
  installPhase = ''
    mkdir -p $out
    cp -r dist/ $out/frontend
    ${installWebsocketServer}
    ${installElectron}
  '';

  meta = {
    homepage = "https://github.com/tableaunoir/tableaunoir";
    description = "A lightweight online blackboard for teaching";
    longDescription = ''
      An online blackboard with fridge magnets for teaching, and making animations and presentations.
      All of that in a lightweight user interface, and without coding.
    '';
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.litchipi ];
  };
}
