{
  lib,
  ddnet,
  fetchFromGitHub,
}:
let
  clientExecutable = "TaterClient-DDNet";
in
ddnet.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "taterclient-ddnet";
    version = "8.5.4";

    src = fetchFromGitHub {
      owner = "sjrc6";
      repo = "taterclient-ddnet";
      rev = finalAttrs.version;
      hash = "sha256-AYKCdnTPfIWbEBBMGQeJ1UO8VybyehJ3SDmtrcAiqfI=";
    };

    # The ddnet nix package patches are not compatible
    patches = [ ];

    cmakeFlags = previousAttrs.cmakeFlags ++ [
      "-DSERVER=OFF"
      "-DTOOLS=OFF"
      "-DCLIENT_EXECUTABLE=${clientExecutable}"
    ];

    meta = {
      description = "Modification of DDNet teeworlds client";
      homepage = "https://github.com/sjrc6/taterclient-ddnet";
      changelog = "https://github.com/sjrc6/taterclient-ddnet/releases";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        melon
        theobori
      ];
      mainProgram = clientExecutable;
    };
  }
)
