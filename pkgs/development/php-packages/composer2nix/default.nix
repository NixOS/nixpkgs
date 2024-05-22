{ pkgs, buildComposerEnv, php, noDev ? true }:

let
  composer2nixPkg = import ./php-packages.nix {
    composerEnv = buildComposerEnv;
    inherit (pkgs) fetchurl fetchgit fetchhg fetchsvn;
  };
in buildComposerEnv.buildPackage rec {
  inherit noDev;
  inherit (composer2nixPkg) packages devPackages;

  pname = "composer2nix";
  version = "0.0.6";

  src = ./.;

  executable = true;
  symlinkDependencies = false;

  # Patch the php file to look for the autoload in the expected place
  #postInstall = ''
  #  substituteInPlace $out/bin/composer2nix \
  #    --replace 'dirname(__FILE__)."/../vendor/autoload.php"' \"$out/share/php/composer2nix-${version}/vendor/autoload.php\"
  #'';

  meta = with pkgs.lib; {
    description = "Generate nix expressions to build PHP packages";
    license = licenses.mit;
    homepage = "https://github.com/svanderburg/composer2nix";
    maintainers = with maintainers; [ onny ];
  };
}
