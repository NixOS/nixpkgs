{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  mkPnpmPackage ? ((callPackage ./mk-pnpm-package/derivation.nix {}).mkPnpmPackage),
}: let
  src = fetchFromGitHub {
    owner = "seriousm4x";
    repo = "UpSnap";
    rev = "b05cf7a4852e818703135871c17d97635ab65c28";
    hash = "sha256-mZdW6yljYOBaWeN3d3qhV9YDyJeIohybg6j81wJ5SCo=";
  };
  version = "4.2.7";
in
  buildGoModule {
    vendorHash = "sha256-K+RMedWT0rR3v/f2e5gP61WffBA2Cy3TDpUhwIiF3gY=";
    pname = "upsnap";
    version = version;

    src = builtins.path {path = "${src}/backend";};

    preBuild = let
      frontend = mkPnpmPackage {
        src = builtins.path {path = "${src}/frontend";};
        distDir = ".";
      };
    in ''
      cp -r ${frontend}/build/* ./pb_public
    '';

    checkPhase = ''
      runHook preCheck
      runHook postCheck
    '';

    CGO_ENABLED = "0";

    meta = with lib; {
      description = "A simple wake on lan web app";
      homepage = "https://github.com/seriousm4x/UpSnap";
      license = licenses.mit;
      maintainers = with maintainers; ["doosty"];
      mainProgram = "upsnap";
      platforms = platforms.all;
    };
  }
