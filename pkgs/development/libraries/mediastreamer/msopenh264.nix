{ stdenv, autoreconfHook, pkgconfig, mediastreamer, openh264
, fetchgit, cmake
}:

stdenv.mkDerivation {
  pname = "mediastreamer-openh264";
  version = "0.0pre20160801";

  src = fetchgit {
    url = "git://git.linphone.org/msopenh264.git";
    rev = "4cb4b134bf0f1538fd0c2c928eee2d5388115abc";
    sha256 = "001km4xy1ifwbg1c19ncc75h867fzfcxy9pxvl4pxqb64169xc1k";
  };

  nativeBuildInputs = [ autoreconfHook cmake pkgconfig ];
  buildInputs = [ mediastreamer openh264 ];

  meta = with stdenv.lib; {
    description = "H.264 encoder/decoder plugin for mediastreamer2";
    homepage = http://www.linphone.org/technical-corner/mediastreamer2/overview;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
