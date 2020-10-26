{ pkgs, nodejs, stdenv }:

let
  since = (version: pkgs.lib.versionAtLeast nodejs.version version);
  before = (version: pkgs.lib.versionOlder nodejs.version version);
  super = import ./composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  self = super // {
    "@angular/cli" = super."@angular/cli".override {
      prePatch = ''
        export NG_CLI_ANALYTICS=false
      '';
    };
    bower2nix = super.bower2nix.override {
      buildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        for prog in bower2nix fetch-bower; do
          wrapProgram "$out/bin/$prog" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.git pkgs.nix ]}
        done
      '';
    };

    coc-imselect = super.coc-imselect.override {
      meta.broken = since "10";
    };

    "fast-cli-1.x" = super."fast-cli-1.x".override {
      meta.broken = since "10";
    };

    jshint = super.jshint.override {
      buildInputs = [ pkgs.phantomjs2 ];
    };

    dat = super.dat.override {
      buildInputs = [ self.node-gyp-build pkgs.libtool pkgs.autoconf pkgs.automake ];
      meta.broken = since "12";
    };

    bitwarden-cli = pkgs.lib.overrideDerivation super."@bitwarden/cli" (drv: {
      name = "bitwarden-cli-${drv.version}";
    });

    fast-cli = super."fast-cli-1.x".override {
      preRebuild = ''
        # Simply ignore the phantomjs --version check. It seems to need a display but it is safe to ignore
        sed -i -e "s|console.error('Error verifying phantomjs, continuing', err)|console.error('Error verifying phantomjs, continuing', err); return true;|" node_modules/phantomjs-prebuilt/lib/util.js
      '';
      buildInputs = [ pkgs.phantomjs2 ];
    };

    git-ssb = super.git-ssb.override {
      buildInputs = [ self.node-gyp-build ];
      meta.broken = since "10";
    };

    insect = super.insect.override (drv: {
      nativeBuildInputs = drv.nativeBuildInputs or [] ++ [ pkgs.psc-package self.pulp ];
    });

    mirakurun = super.mirakurun.override rec {
      nativeBuildInputs = with pkgs; [ makeWrapper ];
      postInstall = let
        runtimeDeps = [ nodejs ] ++ (with pkgs; [ bash which v4l_utils ]);
      in
      ''
        substituteInPlace $out/lib/node_modules/mirakurun/processes.json \
          --replace "/usr/local" ""

        # XXX: Files copied from the Nix store are non-writable, so they need
        # to be given explicit write permissions
        substituteInPlace $out/lib/node_modules/mirakurun/lib/Mirakurun/config.js \
          --replace 'fs.copyFileSync("config/server.yml", path);' \
                    'fs.copyFileSync("config/server.yml", path); fs.chmodSync(path, 0o644);' \
          --replace 'fs.copyFileSync("config/tuners.yml", path);' \
                    'fs.copyFileSync("config/tuners.yml", path); fs.chmodSync(path, 0o644);' \
          --replace 'fs.copyFileSync("config/channels.yml", path);' \
                    'fs.copyFileSync("config/channels.yml", path); fs.chmodSync(path, 0o644);'

        # XXX: The original mirakurun command uses PM2 to manage the Mirakurun
        # server.  However, we invoke the server directly and let systemd
        # manage it to avoid complication. This is okay since no features
        # unique to PM2 is currently being used.
        makeWrapper ${nodejs}/bin/npm $out/bin/mirakurun \
          --add-flags "start" \
          --run "cd $out/lib/node_modules/mirakurun" \
          --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps}
      '';
    };

    node-inspector = super.node-inspector.override {
      buildInputs = [ self.node-pre-gyp ];
      meta.broken = since "10";
    };

    node2nix = super.node2nix.override {
      buildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/node2nix" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.nix ]}
      '';
    };

    node-red = super.node-red.override {
      buildInputs = [ self.node-pre-gyp ];
    };

    pnpm = super.pnpm.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];

      preRebuild = ''
        sed 's/"link:/"file:/g' --in-place package.json
      '';

      postInstall = let
        pnpmLibPath = stdenv.lib.makeBinPath [
          nodejs.passthru.python
          nodejs
        ];
      in ''
        for prog in $out/bin/*; do
          wrapProgram "$prog" --prefix PATH : ${pnpmLibPath}
        done
      '';
    };

    pulp = super.pulp.override {
      # tries to install purescript
      npmFlags = "--ignore-scripts";

      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall =  ''
        wrapProgram "$out/bin/pulp" --suffix PATH : ${stdenv.lib.makeBinPath [
          pkgs.purescript
        ]}
      '';
    };

    ssb-server = super.ssb-server.override {
      buildInputs = [ pkgs.automake pkgs.autoconf self.node-gyp-build ];
      meta.broken = since "10";
    };

    tedicross = super."tedicross-git+https://github.com/TediCross/TediCross.git#v0.8.7".override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        makeWrapper '${nodejs}/bin/node' "$out/bin/tedicross" \
          --add-flags "$out/lib/node_modules/tedicross/main.js"
      '';
    };

    tsun = super.tsun.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/tsun" \
        --prefix NODE_PATH : ${self.typescript}/lib/node_modules
      '';
    });

    stf = super.stf.override {
      meta.broken = since "10";
    };

    webtorrent-cli = super.webtorrent-cli.override {
      buildInputs = [ self.node-gyp-build ];
    };

    joplin = super.joplin.override {
      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = with pkgs; [
        # required by sharp
        # https://sharp.pixelplumbing.com/install
        vips

        self.node-pre-gyp
      ];
      meta.broken = true;
    };

    thelounge = super.thelounge.override {
      buildInputs = [ self.node-pre-gyp ];
      postInstall = ''
        echo /var/lib/thelounge > $out/lib/node_modules/thelounge/.thelounge_home
      '';
    };
  };
in self
