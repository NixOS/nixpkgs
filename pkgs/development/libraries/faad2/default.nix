{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "faad2-2.7";

  src = fetchurl {
    url = mirror://sourceforge/faac/faad2-2.7.tar.bz2;
    sha256 = "1db37ydb6mxhshbayvirm5vz6j361bjim4nkpwjyhmy4ddfinmhl";
  };

  meta = {
    description = "An open source MPEG-4 and MPEG-2 AAC decoder";
    homepage = http://www.audiocoding.com/faad2.html;
    license = stdenv.lib.licenses.gpl2;
  };
}
