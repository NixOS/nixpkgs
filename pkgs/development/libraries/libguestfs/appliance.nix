{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation rec {
  pname = "libguestfs-appliance";
  version = "1.46.0";

  src = fetchurl {
    url = "http://download.libguestfs.org/binaries/appliance/appliance-${version}.tar.xz";
    hash = "sha256-p1UN5wv3y+V5dFMG5yM3bVf1vaoDzQnVv9apfwC4gNg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp README.fixed initrd kernel root $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "VM appliance disk image used in libguestfs package";
    homepage = "https://libguestfs.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    hydraPlatforms = [ ]; # Hydra fails with "Output limit exceeded"
  };
}
