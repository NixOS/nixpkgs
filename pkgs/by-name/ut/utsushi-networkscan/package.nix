{
  lib,
  stdenv,
  fetchurl,
  rpmextract,
}:

stdenv.mkDerivation rec {
  pname = "imagescan-plugin-networkscan";
  imagescanVersion = "3.65.0";
  version = "1.1.4";

  src = fetchurl {
    urls = [
      "https://buzo.eu/mirror/epson/imagescan-bundle-fedora-32-${imagescanVersion}.x64.rpm.tar.gz"
      "https://web.archive.org/web/20221027001620if_/https://download2.ebz.epson.net/imagescanv3/fedora/latest1/rpm/x64/imagescan-bundle-fedora-32-${imagescanVersion}.x64.rpm.tar.gz"
    ];
    sha256 = "sha256-fxi63sV+YJOlv1aVTfCPIXOPfNAo+R7zNPvA11sFmMk=";
  };

  nativeBuildInputs = [ rpmextract ];

  installPhase = ''
    rpmextract plugins/imagescan-plugin-networkscan-${version}-*.x86_64.rpm
    install -Dm755 usr/libexec/utsushi/networkscan $out/libexec/utsushi/networkscan
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath ${lib.makeLibraryPath [ stdenv.cc.cc ]} \
      $out/libexec/utsushi/networkscan
  '';

  meta = with lib; {
    homepage = "https://support.epson.net/linux/en/imagescanv3.php";
    description = "Network scan plugin for ImageScan v3";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
