{lib, stdenv, fetchurl, autoreconfHook, fetchpatch }:

let
  version = "5.6";
in

stdenv.mkDerivation {
  pname = "polyml";
  inherit version;

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.ac --replace stdc++ c++
  '';

  patches = [
    # glibc 2.34 compat
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/polyml/raw/4d8868ca5a1ce3268f212599a321f8011c950496/f/polyml-pthread-stack-min.patch";
      sha256 = "1h5ihg2sxld9ymrl3f2mpnbn2242ka1fsa0h4gl9h90kndvg6kby";
    })
  ];

  nativeBuildInputs = lib.optional stdenv.isDarwin autoreconfHook;

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
