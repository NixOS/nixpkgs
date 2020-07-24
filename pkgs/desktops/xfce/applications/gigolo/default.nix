{ mkXfceDerivation, exo, gtk3, gvfs, glib }:

mkXfceDerivation {
  category = "apps";
  pname = "gigolo";
  version = "0.5.1";
  odd-unstable = false;

  sha256 = "11a35z5apr26nl6fpmbsvvv3xf5w61sgzcb505plavrchpfbdxjn";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk3 glib gvfs ];

  meta = {
    description = "A frontend to easily manage connections to remote filesystems";
  };
}
