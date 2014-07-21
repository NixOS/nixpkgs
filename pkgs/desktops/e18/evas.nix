{ stdenv, fetchurl, pkgconfig, e18, zlib }:
stdenv.mkDerivation rec {
  name = "evas_generic_loaders-${version}";
  version = "1.10.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/libs/evas_generic_loaders/${name}.tar.gz";
    sha256 = "0qx44g7a8pzcgspx8q10zjiwzafis301fhpchd4pskfxhqd4qagm";
  };
  buildInputs = [ pkgconfig e18.efl zlib ];
  meta = {
    description = "Extra image decoders";
    homepage = http://enlightenment.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
