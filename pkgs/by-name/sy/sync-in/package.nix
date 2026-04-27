{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runtimeShell,
  nodejs_24,
  nixosTests,
}: let
  drizzleJsFile = ./drizzle.js;
in
  buildNpmPackage rec {
    pname = "sync-in";
    version = "2.2.0";

    src = fetchFromGitHub {
      owner = "Sync-in";
      repo = "server";
      rev = "v${version}";
      hash = "sha256-PkdVveWfAqEU/Ljs28OZt1QPjE+DqQX4Aet/wCk7eok=";
    };

    nativeBuildInputs = [nodejs_24];

    postPatch = ''
      ${nodejs_24}/bin/npm pkg set dependencies.drizzle-orm="^0.45.2"
      ${nodejs_24}/bin/npm pkg set dependencies.pdfjs-dist="^5.6.205"
      ${nodejs_24}/bin/npm pkg set dependencies.drizzle-kit="^v0.31.10"
    '';

    # npmInstallFlags = "";

    npmDepsHash = "sha256-sOmR+cwIllv9V3JdqLlZnImsgntjS7ahDKXzyxKOS1M=";

    buildPhase = ''
      runHook preBuild
      ${nodejs_24}/bin/npm run build && ${nodejs_24}/bin/node scripts/build/release.mjs


      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp -r . $out/lib

      mkdir -p $out/bin
      mkdir -p $out/conf
      cp ${drizzleJsFile} $out/conf/drizzle.js

      cat > $out/bin/sync-in <<EOF
      #!${runtimeShell}
      export NODE_PATH=$NODE_PATH:$out/lib/node_modules
      exec ${nodejs_24}/bin/node $out/lib/release/sync-in-server/server/main.js "\$@"
      EOF

      cat > $out/bin/sync-in-migrate-db <<EOF
      #!${runtimeShell}
      export NODE_PATH=$NODE_PATH:$out/lib/node_modules
      exec ${nodejs_24}/bin/npx drizzle-kit migrate --config=/etc/sync-in/drizzle.js "\$@"
      EOF

      chmod +x $out/bin/sync-in
      chmod +x $out/bin/sync-in-*

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Sync-in server (self-hosted collaboration platform)";
      license = licenses.agpl3Only;
      platforms = platforms.linux;

      homepage = "https://github.com/Sync-in/server";
      changelog = "https://github.com/Sync-in/server/releases/tag/v${version}";
    };
  }
