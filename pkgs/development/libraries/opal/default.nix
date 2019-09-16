{ stdenv, fetchurl, pkgconfig, ptlib, srtp, libtheora, speex, gnome3
, ffmpeg, x264, cyrus_sasl, openldap, openssl, expat, unixODBC }:

stdenv.mkDerivation rec {
  pname = "opal";
  version = "3.10.10";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "f208985003461b2743575eccac13ad890b3e5baac35b68ddef17162460aff864";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ptlib srtp libtheora speex
                  ffmpeg x264 cyrus_sasl openldap openssl expat unixODBC ];
  propagatedBuildInputs = [ speex ];

  configureFlags = [ "--enable-h323" ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-D__STDC_CONSTANT_MACROS=1 -std=gnu++98";

  patches = [ ./disable-samples-ftbfs.diff ./libav9.patch ./libav10.patch ];

  meta = with stdenv.lib; {
    description = "VoIP library";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    homepage = "http://www.opalvoip.org/";
    license = with licenses; [ bsdOriginal mpl10 gpl2Plus lgpl21 ];
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://ftp.gnome.org/pub/GNOME/sources/opal";
    };
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };
}

