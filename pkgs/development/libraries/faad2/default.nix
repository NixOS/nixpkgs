{stdenv, fetchurl
, drmSupport ? false # Digital Radio Mondiale
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "faad2-${version}";
  version = "2.8.8";

  src = fetchurl {
    url = "mirror://sourceforge/faac/${name}.tar.gz";
    sha256 = "1db37ydb6mxhshbayvirm5vz6j361bjim4nkpwjyhmy4ddfinmhl";
  };

  configureFlags = []
    ++ optional drmSupport "--with-drm";

  meta = {
    description = "An open source MPEG-4 and MPEG-2 AAC decoder";
    homepage    = https://www.audiocoding.com/faad2.html;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
