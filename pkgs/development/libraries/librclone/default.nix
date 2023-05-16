{ lib
, stdenv
, buildGoModule
, rclone
}:

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in buildGoModule rec {
  pname = "librclone";
<<<<<<< HEAD
  inherit (rclone) version src vendorHash;

  patches = rclone.patches or [ ];
=======
  inherit (rclone) version src vendorSha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildPhase = ''
    runHook preBuild
    cd librclone
    go build --buildmode=c-shared -o librclone${ext} github.com/rclone/rclone/librclone
<<<<<<< HEAD
    runHook postBuild
=======
    runHook postBuildd
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/lib librclone${ext}
    install -Dt $out/include librclone.h
    runHook postInstall
  '';

  meta = {
    description = "Rclone as a C library";
    homepage = "https://github.com/rclone/rclone/tree/master/librclone";
    maintainers = with lib.maintainers; [ dotlambda ];
    inherit (rclone.meta) license platforms;
  };
}
