{ stdenv, fetchurl, sqlite, zlib, proj, geos }:

stdenv.mkDerivation rec {
  name = "libspatialite-4.1.1";

  src = fetchurl {
    url = "http://www.gaia-gis.it/gaia-sins/${name}.tar.gz";
    sha256 = "03wikddl60ly0yh8szrra1ng2iccsdzz645vkn6a7x2jz45a5084";
  };

  buildInputs = [ sqlite zlib proj geos ];

  configureFlags = "--disable-freexl";

  enableParallelBuilding = true;

  meta = {
    description = "Extensible spatial index library in C++";
    homepage = https://www.gaia-gis.it/fossil/libspatialite;
    # They allow any of these
    license = [ "GPLv2+" "LGPLv2+" "MPL1.1" ];
  };
}
