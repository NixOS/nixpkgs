{ stdenv, fetchurl, autoreconfHook, pkgconfig, mediastreamer, openh264
, fetchgit, cmake
}:

stdenv.mkDerivation rec {
  name = "mediastreamer-openh264-${version}";
  version = "0.0pre20160801";

  src = fetchgit {
    url = "git://git.linphone.org/msopenh264.git";
    rev = "4cb4b134bf0f1538fd0c2c928eee2d5388115abc";
    sha256 = "001km4xy1ifwbg1c19ncc75h867fzfcxy9pxvl4pxqb64169xc1k";
  };

  buildInputs = [ autoreconfHook pkgconfig mediastreamer openh264 ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "H.264 encoder/decoder plugin for mediastreamer2";
    homepage = http://www.linphone.org/technical-corner/mediastreamer2/overview;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
