{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "libguestfs-appliance";
  version = "1.40.1";

  src = fetchurl {
    url = "http://download.libguestfs.org/binaries/appliance/appliance-${version}.tar.xz";
    hash = "sha256-Gq8L7xhRS46evQxhMO1RiLb2pwUuSJHV82IAePSFY+Y=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp README.fixed initrd kernel root $out

    runHook postInstall
  '';

  meta = {
    hydraPlatforms = []; # Hydra fails with "Output limit exceeded"
  };
}
