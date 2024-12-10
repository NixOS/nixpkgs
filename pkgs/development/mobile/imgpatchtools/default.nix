{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "imgpatchtools";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "erfanoabdi";
    repo = "imgpatchtools";
    rev = version;
    sha256 = "sha256-7TOkqaXPui14VcSmMmYJ1Wg+s85wrgp+E0XcCB0Ml7M=";
  };

  buildInputs = [
    bzip2
    openssl
    zlib
  ];

  installPhase = "install -Dt $out/bin bin/*";

  meta = with lib; {
    description = "Tools to manipulate Android OTA archives";
    longDescription = ''
      This package is useful for Android development. In particular, it can be
      used to extract ext4 /system image from Android distribution ZIP archives
      such as those distributed by LineageOS and Replicant, via BlockImageUpdate
      utility. It also includes other, related, but arguably more advanced tools
      for OTA manipulation.
    '';
    homepage = "https://github.com/erfanoabdi/imgpatchtools";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.linux;
  };
}
