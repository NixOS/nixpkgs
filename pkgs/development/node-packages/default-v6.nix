{pkgs, system, nodejs}:

let
  nodePackages = import ./composition-v5.nix {
    inherit pkgs system nodejs;
  };
in
nodePackages // {
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
}
