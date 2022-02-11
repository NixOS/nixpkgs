{lib, stdenv, fetchurl, autoreconfHook}:

let
  version = "5.6";
in

stdenv.mkDerivation {
  pname = "polyml";
  inherit version;

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.ac --replace stdc++ c++
  '';

  buildInputs = lib.optional stdenv.isDarwin autoreconfHook;

  src = fetchurl {
    url = "mirror://sourceforge/polyml/polyml.${version}.tar.gz";
    sha256 = "05d6l2a5m9jf32a8kahwg2p2ph4x9rjf1nsl83331q3gwn5bkmr0";
  };

  meta = {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = "https://www.polyml.org/";
    license = lib.licenses.lgpl21;
    platforms = with lib.platforms; linux;
    maintainers = [ #Add your name here!
      lib.maintainers.maggesi
    ];
  };
}
