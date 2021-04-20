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

    aws-azure-login = super.aws-azure-login.override {
      meta.platforms = pkgs.lib.platforms.linux;
      nativeBuildInputs = [ pkgs.makeWrapper ];
      prePatch = ''
        export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
      '';
      postInstall = ''
        wrapProgram $out/bin/aws-azure-login \
            --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium}/bin/chromium
      '';
    };

    bower2nix = super.bower2nix.override {
      buildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        for prog in bower2nix fetch-bower; do
          wrapProgram "$out/bin/$prog" --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.git pkgs.nix ]}
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

    # NOTE: this is a stub package to fetch npm dependencies for
    # ../../applications/video/epgstation
    epgstation = super."epgstation-../../applications/video/epgstation".override (drv: {
      meta = drv.meta // {
        broken = true; # not really broken, see the comment above
      };
    });

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

    flood = super.flood.override {
      buildInputs = [ self.node-pre-gyp ];
    };

    expo-cli = super."expo-cli".override (attrs: {
      # The traveling-fastlane-darwin optional dependency aborts build on Linux.
      dependencies = builtins.filter (d: d.packageName != "@expo/traveling-fastlane-${if stdenv.isLinux then "darwin" else "linux"}") attrs.dependencies;
    });

    "@electron-forge/cli" = super."@electron-forge/cli".override {
      buildInputs = [ self.node-pre-gyp self.rimraf ];
    };

    git-ssb = super.git-ssb.override {
      buildInputs = [ self.node-gyp-build ];
      meta.broken = since "10";
    };

    hsd = super.hsd.override {
      buildInputs = [ self.node-gyp-build pkgs.unbound ];
    };

    ijavascript = super.ijavascript.override (oldAttrs: {
      preRebuild = ''
        export NPM_CONFIG_ZMQ_EXTERNAL=true
      '';
      buildInputs = oldAttrs.buildInputs ++ [ self.node-gyp-build pkgs.zeromq ];
    });

    insect = super.insect.override (drv: {
      nativeBuildInputs = drv.nativeBuildInputs or [] ++ [ pkgs.psc-package self.pulp ];
    });

    makam =  super.makam.override {
      buildInputs = [ pkgs.nodejs pkgs.makeWrapper ];
      postFixup = ''
        wrapProgram "$out/bin/makam" --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
        ${
          if stdenv.isLinux
            then "patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \"$out/lib/node_modules/makam/makam-bin-linux64\""
            else ""
        }
      '';
    };

    mirakurun = super.mirakurun.override rec {
      nativeBuildInputs = with pkgs; [ makeWrapper ];
      postInstall = let
        runtimeDeps = [ nodejs ] ++ (with pkgs; [ bash which v4l-utils ]);
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
        wrapProgram "$out/bin/node2nix" --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nix ]}
      '';
    };

    node-red = super.node-red.override {
      buildInputs = [ self.node-pre-gyp ];
    };

    mermaid-cli = super."@mermaid-js/mermaid-cli".override (
    if stdenv.isDarwin
    then {}
    else {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      prePatch = ''
        export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
      '';
      postInstall = ''
        wrapProgram $out/bin/mmdc \
        --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium.outPath}/bin/chromium
      '';
    });

    pnpm = super.pnpm.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];

      preRebuild = ''
        sed 's/"link:/"file:/g' --in-place package.json
      '';

      postInstall = let
        pnpmLibPath = pkgs.lib.makeBinPath [
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
        wrapProgram "$out/bin/pulp" --suffix PATH : ${pkgs.lib.makeBinPath [
          pkgs.purescript
        ]}
      '';
    };

    ssb-server = super.ssb-server.override {
      buildInputs = [ pkgs.automake pkgs.autoconf self.node-gyp-build ];
      meta.broken = since "10";
    };

    stf = super.stf.override {
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

    typescript-language-server = super.typescript-language-server.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/typescript-language-server" \
          --prefix PATH : ${pkgs.lib.makeBinPath [ self.typescript ]}
      '';
    };

    teck-programmer = super.teck-programmer.override {
      buildInputs = [ pkgs.libusb ];
    };

    vega-cli = super.vega-cli.override {
      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = with pkgs; [
        super.node-pre-gyp
        pixman
        cairo
        pango
        libjpeg
      ];
    };

    vega-lite = super.vega-lite.override {
        # npx tries to install vega from scratch at vegalite runtime if it
        # can't find it. We thus replace it with a direct call to the nix
        # derivation. This might not be necessary anymore in future vl
        # versions: https://github.com/vega/vega-lite/issues/6863.
        postInstall = ''
          substituteInPlace $out/lib/node_modules/vega-lite/bin/vl2pdf \
            --replace "npx -p vega vg2pdf"  "${self.vega-cli}/bin/vg2pdf"
          substituteInPlace $out/lib/node_modules/vega-lite/bin/vl2svg \
            --replace "npx -p vega vg2svg"  "${self.vega-cli}/bin/vg2svg"
          substituteInPlace $out/lib/node_modules/vega-lite/bin/vl2png \
            --replace "npx -p vega vg2png"  "${self.vega-cli}/bin/vg2png"
        '';
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

        libsecret
        self.node-gyp-build
        self.node-pre-gyp
      ];
    };

    thelounge = super.thelounge.override {
      buildInputs = [ self.node-pre-gyp ];
      postInstall = ''
        echo /var/lib/thelounge > $out/lib/node_modules/thelounge/.thelounge_home
      '';
    };

    yaml-language-server = super.yaml-language-server.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/yaml-language-server" \
        --prefix NODE_PATH : ${self.prettier}/lib/node_modules
      '';
    };
  };
in self
