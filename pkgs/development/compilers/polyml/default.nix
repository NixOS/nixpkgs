{stdenv, fetchurl}:

let
  version = "5.5.1";
in

stdenv.mkDerivation {
  name = "polyml-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/polyml/polyml.${version}.tar.gz";
    sha256 = "16i0ir5mydl7381aijihkll19khp3z8dq0g2ja6k0pcbpkd0k06g";
  };

  meta = {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = http://www.polyml.org/;
    license = stdenv.lib.licenses.lgpl21;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = [ #Add your name here!
      stdenv.lib.maintainers.z77z
    ];
  };
}
