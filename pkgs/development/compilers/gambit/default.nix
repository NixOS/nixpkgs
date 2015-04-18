{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "gambit-${version}";
  version = "4.7.3";
  devver  = "4_7_3";

  src = fetchurl {
    url    = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.7/source/gambc-v${devver}-devel.tgz";
    sha256 = "12jbr6bc0zmc7vw07a9pliadbvqgwkpmw6cj8awz73clv1j7pxha";
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
