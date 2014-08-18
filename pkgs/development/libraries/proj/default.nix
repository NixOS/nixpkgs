{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "proj-4.5.0";

  src = fetchurl {
    url = ftp://ftp.remotesensing.org/proj/proj-4.5.0.tar.gz;
    sha256 = "1d2qz0vgp13hkfgaz7hkblhb9w2fh2blbjqz73xdinwc08cmflqv";
  };

  meta = { 
    description = "Cartographic Projections Library";
    homepage = http://proj.maptools.org;
    license = stdenv.lib.licenses.mit;
  };
}
