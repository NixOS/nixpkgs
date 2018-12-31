{ stdenv, fetchurl, ladspaH, libjack2, liblo, alsaLib, qt4, libX11, libsndfile, libSM
, libsamplerate, libtool, autoconf, automake, xorgproto, libICE, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "dssi-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/dssi/dssi/${version}/${name}.tar.gz";
    sha256 = "0kl1hzhb7cykzkrqcqgq1dk4xcgrcxv0jja251aq4z4l783jpj7j";
  };

  buildInputs =
    [ ladspaH libjack2 liblo alsaLib qt4 libX11 libsndfile libSM
      libsamplerate libtool autoconf automake xorgproto libICE pkgconfig
    ];

  meta = with stdenv.lib; {
    description = "A plugin SDK for virtual instruments";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
    downloadPage = "https://sourceforge.net/projects/dssi/files/dssi/";
  };
}
