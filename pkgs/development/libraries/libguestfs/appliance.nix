<<<<<<< HEAD
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
=======
{ fetchzip }:

fetchzip {
  name = "libguestfs-appliance-1.40.1";
  url = "http://download.libguestfs.org/binaries/appliance/appliance-1.40.1.tar.xz";
  sha256 = "00863mm08p55cv6w8awp7y0lv894rcrm70mjwqfc8nc4yyb70xlm";

  meta = {
    hydraPlatforms = []; # Hydra fails with "Output limit exceeded"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
