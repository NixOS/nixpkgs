{ lib, stdenv, fetchurl, libarchive }:

stdenv.mkDerivation rec {
  pname = "virtio-win";
  version = "0.1.240-1";

  src = fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-${version}/virtio-win.iso";
    hash = "sha256-69SCWGaPf3jgJu0nbCip0Z2D4CD/oICtaZENyGu8vMY=";
  };

  nativeBuildInputs = [
    libarchive
  ];

  unpackCmd = "mkdir source; bsdtar -xf $curSrc -C source";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R ./. $out/

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Windows VirtIO Drivers";
    homepage = "https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html";
    changelog = "https://fedorapeople.org/groups/virt/virtio-win/CHANGELOG";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ anthonyroussel ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
  };
}
