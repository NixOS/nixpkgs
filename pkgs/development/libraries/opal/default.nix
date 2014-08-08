{ stdenv, fetchurl, pkgconfig, ptlib, srtp, libtheora, speex
, ffmpeg, x264, cyrus_sasl, openldap, openssl, expat, unixODBC }:

stdenv.mkDerivation rec {
  name = "opal-3.10.10";

  src = fetchurl {
    url = "mirror://gnome/sources/opal/3.10/${name}.tar.xz";
    sha256 = "f208985003461b2743575eccac13ad890b3e5baac35b68ddef17162460aff864";
  };

  buildInputs = [ pkgconfig ptlib srtp libtheora speex
                  ffmpeg x264 cyrus_sasl openldap openssl expat unixODBC ];
  propagatedBuildInputs = [ speex ]; 

  configureFlags = [ "--enable-h323" ];

  enableParallelBuilding = true;

  NIX_CFLAGS = "-D__STDC_CONSTANT_MACROS=1";

  patches = [ ./disable-samples-ftbfs.diff ./libav9.patch ./libav10.patch ];
      
  meta = with stdenv.lib; {
    description = "OPAL VoIP library";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://ftp.gnome.org/pub/GNOME/sources/opal";
    };
  };
}

