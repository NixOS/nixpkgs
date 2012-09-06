{stdenv, fetchurl}:

let
  version = "5.4.1";
in

stdenv.mkDerivation {
  name = "polyml-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/polyml/polyml.${version}.tar.gz";
    sha256 = "514d1d07be487b783d4dfa29dbd550b3396640579ce135a9eb5a61f08e7f9cac";
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
