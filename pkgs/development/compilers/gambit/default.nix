{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "gambit-${version}";
  version = "4.8.5";
  devver  = "4_8_5";

  src = fetchurl {
    url    = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.8/source/gambit-v${devver}-devel.tgz";
    sha256 = "02b5bm06k2qr0lvdwwsl0ygxs7n8410rrkq95picn4s02kxszqnq";
  };

  configureFlags = [ "--enable-shared" "--enable-single-host" ];

  meta = {
    description = "Optimizing Scheme to C compiler";
    homepage    = "http://gambitscheme.org";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin ];
  };
}
