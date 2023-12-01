{ fetchzip }:

rec {
  pname = "irrlicht";
  version = "1.8.4";

  src = fetchzip {
    url = "mirror://sourceforge/irrlicht/${pname}-${version}.zip";
    sha256 = "02sq067fn4xpf0lcyb4vqxmm43qg2nxx770bgrl799yymqbvih5f";
  };
}
