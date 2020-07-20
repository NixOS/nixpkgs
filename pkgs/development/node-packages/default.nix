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
      meta.broken = since "10";
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
    };

    thelounge = super.thelounge.override {
      buildInputs = [ self.node-pre-gyp ];
      postInstall = ''
        echo /var/lib/thelounge > $out/lib/node_modules/thelounge/.thelounge_home
      '';
    };
  };
in self
