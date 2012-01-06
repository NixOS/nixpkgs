{stdenv, fetchurl, xz, alsaLib}:

stdenv.mkDerivation {
  name = "audiofile-0.3.2";

  src = fetchurl {
    url = mirror://gnome/sources/audiofile/0.3/audiofile-0.3.2.tar.xz;
    sha256 = "185j69j6b0vp6h6bb4j4ipvcyysxf63ghxnvdhh8kbc7ixm71hgs";
  };

  buildNativeInputs = [ xz ];

  buildInputs = [ alsaLib ];
}
