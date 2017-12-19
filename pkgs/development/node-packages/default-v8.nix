{pkgs, system, nodejs, stdenv}:

let
  nodePackages = import ./composition-v8.nix {
    inherit pkgs system nodejs;
  };
in
nodePackages // {
  dnschain =  nodePackages.dnschain.override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper nodePackages.coffee-script ];
    postInstall = ''
      wrapProgram $out/bin/dnschain --suffix PATH : ${pkgs.openssl.bin}/bin
    '';
  });

  node-inspector = nodePackages.node-inspector.override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ nodePackages.node-pre-gyp ];
  });
  
  phantomjs = nodePackages.phantomjs.override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.phantomjs2 ];
  });
  
  webdrvr = nodePackages.webdrvr.override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.phantomjs ];
    
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
  });

  npm2nix = nodePackages."npm2nix-git://github.com/NixOS/npm2nix.git#5.12.0".override {
    postInstall = "npm run-script prepublish";
  };

  bower2nix = nodePackages.bower2nix.override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper ];
    postInstall = ''
      for prog in bower2nix fetch-bower; do
        wrapProgram "$out/bin/$prog" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.git pkgs.nix ]}
      done
    '';
  });

  ios-deploy = nodePackages.ios-deploy.override (oldAttrs: {
    preRebuild = ''
      tmp=$(mktemp -d)
      ln -s /usr/bin/xcodebuild $tmp
      export PATH="$PATH:$tmp"
    '';
  });

  fast-cli = nodePackages."fast-cli-1.x".override (oldAttrs: {
    preRebuild = ''
      # Simply ignore the phantomjs --version check. It seems to need a display but it is safe to ignore
      sed -i -e "s|console.error('Error verifying phantomjs, continuing', err)|console.error('Error verifying phantomjs, continuing', err); return true;|" node_modules/phantomjs-prebuilt/lib/util.js
    '';
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.phantomjs2 ];
  });
}
