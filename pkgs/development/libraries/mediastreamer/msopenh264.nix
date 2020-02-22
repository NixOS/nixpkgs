{ stdenv, autoreconfHook, pkgconfig, mediastreamer, openh264
, fetchurl, fetchpatch, cmake
}:

stdenv.mkDerivation rec {
  pname = "mediastreamer-openh264";
  version = "1.2.1";

  src = fetchurl {
    url = "https://www.linphone.org/releases/sources/plugins/msopenh264/msopenh264-${version}.tar.gz";
    sha256 = "0rdxgazm52560g52pp6mp3mwx6j1z3h2zyizzfycp8y8zi92fqm8";
  };

  patches = [
    (fetchpatch {
      name = "msopenh264-build-with-openh264-v2.patch";
      url = "https://git.pld-linux.org/?p=packages/mediastreamer-plugin-msopenh264.git;a=blob_plain;f=mediastreamer-plugin-msopenh264-openh264.patch;hb=344b8af379701a7e58b4ffb3cbac1517eff079fd";
      sha256 = "10c24b0afchx78q28176pd8iz7i1nlf57f6v6lyqxpz60fm5nrcc";
    })
  ];

  nativeBuildInputs = [ autoreconfHook cmake pkgconfig ];
  buildInputs = [ mediastreamer openh264 ];

  meta = with stdenv.lib; {
    description = "H.264 encoder/decoder plugin for mediastreamer2";
    homepage = "https://www.linphone.org/technical-corner/mediastreamer2";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
