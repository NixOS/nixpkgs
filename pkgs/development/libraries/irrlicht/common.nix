{ fetchzip }:

rec {
  pname = "irrlicht";
  version = "1.8.5";

  src = fetchzip {
    url = "mirror://sourceforge/irrlicht/${pname}-${version}.zip";
    hash = "sha256-cTkzxquMLl84/cSDZnSSQsmXRX/htV8M5NUTbnQuHoM=";
  };
}
