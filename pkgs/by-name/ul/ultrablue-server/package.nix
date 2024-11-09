{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "ultrablue-server";
  version = "unstable-fosdem2023";

  src = fetchFromGitHub {
    owner = "ANSSI-FR";
    repo = "ultrablue";
    # Do not use a more recent
    rev = "tags/fosdem-2023";
    hash = "sha256-rnUbgZI+SycYCDUoSziOy+WxRFvyM3XJWJnk3+t0eb4=";
    # rev = "6de04af6e353e38c030539c5678e5918f64be37e";
  };

  sourceRoot = "${src.name}/server";

  vendorHash = "sha256-249LWguTHIF0HNIo8CsE/HWpAtBw4P46VPvlTARLTpw=";
  doCheck = false;

  meta = with lib; {
    description = "User-friendly Lightweight TPM Remote Attestation over Bluetooth";
    mainProgram = "ultrablue-server";
    homepage = "https://github.com/ANSSI-FR/ultrablue";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
