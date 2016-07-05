{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  version = "7.48.0";

  name = "libgnurl-${version}";

  src = fetchurl {
    url = "https://gnunet.org/sites/default/files/gnurl-7_48_0.tar.bz2";
    sha256 = "14gch4rdibrc8qs4mijsczxvl45dsclf234g17dk6c8nc2s4bm0a";
  };

  buildInputs = [ perl ];

  preConfigure = ''
    sed -e 's|/usr/bin|/no-such-path|g' -i.bak configure
  '';

  meta = with stdenv.lib; {
    description = "A fork of libcurl used by GNUnet";
    homepage    = https://gnunet.org/gnurl;
    maintainers = with maintainers; [ falsifian vrthra ];
    hydraPlatforms = platforms.linux;
  };
}
