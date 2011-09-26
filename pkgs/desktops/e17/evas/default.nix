{ stdenv, fetchurl, pkgconfig, eina, freetype }:
stdenv.mkDerivation rec {
  name = "evas-${version}";
  version = "1.0.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "0xkwyvxy32dwja0i3j8r8bzlybjwlrgmrhcri1bscp3aaj75x2rx";
  };
  buildInputs = [ pkgconfig eina freetype ];
  meta = {
    description = "Enlightenment's canvas and scenegraph rendering library";
    longDescription = ''
      Enlightenment's Evas is a clean display canvas API that
      implements a scene graph, not an immediate-mode rendering
      target, is cross-platform, for several target display systems
      that can draw anti-aliased text, smooth super and sub-sampled
      scaled images, alpha-blend objects and much more.
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
