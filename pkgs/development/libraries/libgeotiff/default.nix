{ stdenv, fetchFromGitHub, libtiff, libjpeg, proj, zlib, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.5.1";
  pname = "libgeotiff";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "libgeotiff";
    rev = version;
    sha256 = "081ag23pn2n5y4fkb2rnh4hmcnq92siqiqv0s20jmx0j3s2nvfxy";
  };

  outputs = [ "out" "dev" ];

  sourceRoot = "source/libgeotiff";

  configureFlags = [
    "--with-jpeg=${libjpeg.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libtiff proj ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Library implementing attempt to create a tiff based interchange format for georeferenced raster imagery";
    homepage = "https://github.com/OSGeo/libgeotiff";
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
