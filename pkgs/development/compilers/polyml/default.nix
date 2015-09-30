{stdenv, fetchurl, autoreconfHook}:

let
  version = "5.5.2";
in

stdenv.mkDerivation {
  name = "polyml-${version}";

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.ac --replace stdc++ c++
  '';

  buildInputs = stdenv.lib.optional stdenv.isDarwin autoreconfHook;

  src = fetchurl {
    url = "mirror://sourceforge/polyml/polyml.${version}.tar.gz";
    sha256 = "10m680qdad6bd50bav9xjsgmsxw8yxg55vr7grbg0gvykzl2pzbk";
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
