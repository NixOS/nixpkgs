{ fetchzip }:

fetchzip {
  name = "libguestfs-appliance-1.38.0";
  url = "http://libguestfs.org/download/binaries/appliance/appliance-1.38.0.tar.xz";
  sha256 = "15rxwj5qjflizxk7slpbrj9lcwkd2lgm52f5yv101qba4yyn3g76";

  meta = {
    hydraPlatforms = []; # Hydra fails with "Output limit exceeded"
  };
}
