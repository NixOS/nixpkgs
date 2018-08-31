{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./composition-v6.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages // {
  dat = nodePackages.dat.override {
    buildInputs = [ nodePackages.node-gyp-build ];
  };

  dnschain = nodePackages.dnschain.override {
    buildInputs = [ pkgs.makeWrapper nodePackages.coffee-script ];
    postInstall = ''
      wrapProgram $out/bin/dnschain --suffix PATH : ${pkgs.openssl.bin}/bin
    '';
  };

  node-inspector = nodePackages.node-inspector.override {
    buildInputs = [ nodePackages.node-pre-gyp ];
  };

  phantomjs = nodePackages.phantomjs.override {
    buildInputs = [ pkgs.phantomjs2 ];
  };

  webdrvr = nodePackages.webdrvr.override {
    buildInputs = [ pkgs.phantomjs ];

    preRebuild = ''
      mkdir $TMPDIR/webdrvr

      ln -s ${pkgs.fetchurl {
        url = "https://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar";
        sha1 = "ef1b5f8ae9c99332f99ba8794988a1d5b974d27b";
      }} $TMPDIR/webdrvr/selenium-server-standalone-2.43.1.jar
      ln -s ${pkgs.fetchurl {
        url = "http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip";
        sha1 = "26220f7e43ee3c0d714860db61c4d0ecc9bb3d89";
      }} $TMPDIR/webdrvr/chromedriver_linux64.zip
    '';

    dontNpmInstall = true; # We face an error with underscore not found, but the package will work fine if we ignore this.
  };

  npm2nix = nodePackages."npm2nix-git://github.com/NixOS/npm2nix.git#5.12.0".override {
    postInstall = "npm run-script prepublish";
  };

  bower2nix = nodePackages.bower2nix.override {
    buildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      for prog in bower2nix fetch-bower; do
        wrapProgram "$out/bin/$prog" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.git pkgs.nix ]}
      done
    '';
  };

  ios-deploy = nodePackages.ios-deploy.override {
    preRebuild = ''
      LD=$CC
      tmp=$(mktemp -d)
      ln -s /usr/bin/xcodebuild $tmp
      export PATH="$PATH:$tmp"
    '';
  };

  fast-cli = nodePackages."fast-cli-1.x".override {
    preRebuild = ''
      # Simply ignore the phantomjs --version check. It seems to need a display but it is safe to ignore
      sed -i -e "s|console.error('Error verifying phantomjs, continuing', err)|console.error('Error verifying phantomjs, continuing', err); return true;|" node_modules/phantomjs-prebuilt/lib/util.js
    '';
    buildInputs = [ pkgs.phantomjs2 ];
  };

  node2nix =  nodePackages.node2nix.override {
    buildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram "$out/bin/node2nix" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.nix ]}
    '';
  };
}
