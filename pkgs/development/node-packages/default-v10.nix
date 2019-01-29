{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./composition-v10.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages // {
  bower2nix = nodePackages.bower2nix.override {
    buildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      for prog in bower2nix fetch-bower; do
        wrapProgram "$out/bin/$prog" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.git pkgs.nix ]}
      done
    '';
  };

  jshint = nodePackages.jshint.override {
    buildInputs = [ pkgs.phantomjs2 ];
  };

  dat = nodePackages.dat.override {
    buildInputs = [ nodePackages.node-gyp-build ];
  };

  dnschain = nodePackages.dnschain.override {
    buildInputs = [ pkgs.makeWrapper nodePackages.coffee-script ];
    postInstall = ''
      wrapProgram $out/bin/dnschain --suffix PATH : ${pkgs.openssl.bin}/bin
    '';
  };

  ios-deploy = nodePackages.ios-deploy.override (drv: {
    nativeBuildInputs = drv.nativeBuildInputs or [] ++ [ pkgs.buildPackages.rsync ];
    preRebuild = ''
      LD=$CC
      tmp=$(mktemp -d)
      ln -s /usr/bin/xcodebuild $tmp
      export PATH="$PATH:$tmp"
    '';
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
  };

  node-inspector = nodePackages.node-inspector.override {
    buildInputs = [ nodePackages.node-pre-gyp ];
  };

  node2nix =  nodePackages.node2nix.override {
    buildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram "$out/bin/node2nix" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.nix ]}
    '';
  };

  npm2nix = nodePackages."npm2nix-git://github.com/NixOS/npm2nix.git#5.12.0".override {
    postInstall = "npm run-script prepublish";
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

  scuttlebot = nodePackages.scuttlebot.override {
    buildInputs = [ pkgs.automake pkgs.autoconf nodePackages.node-gyp-build ];
  };

  webtorrent-cli = nodePackages.webtorrent-cli.override {
    buildInputs = [ nodePackages.node-gyp-build ];
  };

}
