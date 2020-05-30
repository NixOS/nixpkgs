{ pkgs, nodejs, stdenv }:

let
  since = (version: pkgs.lib.versionAtLeast nodejs.version version);
  before = (version: pkgs.lib.versionOlder nodejs.version version);
  nodePackages = import ./composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages // {
  "@angular/cli" = nodePackages."@angular/cli".override {
    prePatch = ''
      export NG_CLI_ANALYTICS=false
    '';
  };
  bower2nix = nodePackages.bower2nix.override {
    buildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      for prog in bower2nix fetch-bower; do
        wrapProgram "$out/bin/$prog" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.git pkgs.nix ]}
      done
    '';
  };

  coc-imselect = nodePackages.coc-imselect.override {
    meta.broken = since "10";
  };

  "fast-cli-1.x" = nodePackages."fast-cli-1.x".override {
    meta.broken = since "10";
  };

  jshint = nodePackages.jshint.override {
    buildInputs = [ pkgs.phantomjs2 ];
  };

  dat = nodePackages.dat.override {
    buildInputs = [ nodePackages.node-gyp-build pkgs.libtool pkgs.autoconf pkgs.automake ];
    meta.broken = since "12";
  };

  dnschain = nodePackages.dnschain.override {
    buildInputs = [ pkgs.makeWrapper nodePackages.coffee-script ];
    postInstall = ''
      wrapProgram $out/bin/dnschain --suffix PATH : ${pkgs.openssl.bin}/bin
    '';
    meta.broken = since "14";
  };

  bitwarden-cli = pkgs.lib.overrideDerivation nodePackages."@bitwarden/cli" (drv: {
    name = "bitwarden-cli-${drv.version}";
  });

  ios-deploy = nodePackages.ios-deploy.override (drv: {
    nativeBuildInputs = drv.nativeBuildInputs or [] ++ [ pkgs.buildPackages.rsync ];
    preRebuild = ''
      LD=$CC
      tmp=$(mktemp -d)
      ln -s /usr/bin/xcodebuild $tmp
      export PATH="$PATH:$tmp"
    '';
    meta.platforms = [ pkgs.lib.platforms.darwin ];
  });

  fast-cli = nodePackages."fast-cli-1.x".override {
    preRebuild = ''
      # Simply ignore the phantomjs --version check. It seems to need a display but it is safe to ignore
      sed -i -e "s|console.error('Error verifying phantomjs, continuing', err)|console.error('Error verifying phantomjs, continuing', err); return true;|" node_modules/phantomjs-prebuilt/lib/util.js
    '';
    buildInputs = [ pkgs.phantomjs2 ];
  };

  git-ssb = nodePackages.git-ssb.override {
    buildInputs = [ nodePackages.node-gyp-build ];
    meta.broken = since "10";
  };

  insect = nodePackages.insect.override (drv: {
    nativeBuildInputs = drv.nativeBuildInputs or [] ++ [ pkgs.psc-package pkgs.purescript nodePackages.pulp ];
    meta.broken = since "10";
  });

  node-inspector = nodePackages.node-inspector.override {
    buildInputs = [ nodePackages.node-pre-gyp ];
    meta.broken = since "10";
  };

  node2nix =  nodePackages.node2nix.override {
    buildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram "$out/bin/node2nix" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.nix ]}
    '';
  };

  node-red = nodePackages.node-red.override {
    meta.broken = since "10";
  };

  pnpm = nodePackages.pnpm.override {
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

  pulp = nodePackages.pulp.override {
    npmFlags = "--ignore-scripts";
  };

  ssb-server = nodePackages.ssb-server.override {
    buildInputs = [ pkgs.automake pkgs.autoconf nodePackages.node-gyp-build ];
    meta.broken = since "10";
  };

  tedicross = nodePackages."tedicross-git+https://github.com/TediCross/TediCross.git#v0.8.7".override {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      makeWrapper '${nodejs}/bin/node' "$out/bin/tedicross" \
        --add-flags "$out/lib/node_modules/tedicross/main.js"
    '';
  };

  stf = nodePackages.stf.override {
    meta.broken = since "10";
  };

  webtorrent-cli = nodePackages.webtorrent-cli.override {
    buildInputs = [ nodePackages.node-gyp-build ];
  };

  joplin = nodePackages.joplin.override {
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = with pkgs; [
      # required by sharp
      # https://sharp.pixelplumbing.com/install
      vips

      nodePackages.node-pre-gyp
    ];
  };

  thelounge = nodePackages.thelounge.override {
    buildInputs = [ nodePackages.node-pre-gyp ];
  };
}
