{ fetchzip }:

fetchzip {
  name = "libguestfs-appliance-1.40.1";
  url = "http://download.libguestfs.org/binaries/appliance/appliance-1.40.1.tar.xz";
  sha256 = "00863mm08p55cv6w8awp7y0lv894rcrm70mjwqfc8nc4yyb70xlm";

  meta = {
    hydraPlatforms = []; # Hydra fails with "Output limit exceeded"
  };
}
