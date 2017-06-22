{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "gambit-${version}";
  version = "4.8.6";
  devver  = "4_8_6";

  src = fetchurl {
    url    = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.8/source/gambit-v${devver}-devel.tgz";
    sha256 = "0j3ka76cfb007rlcc3nv5p1s6vh31cwp87hwwabawf16vs1jb7bl";
  };

  configureFlags = [
    "--enable-single-host"
    "--enable-shared"
    "--enable-absolute-shared-libs"
    "--enable-c-opt=-O6" "--enable-gcc-opts" "--enable-inline-jumps"
    "--enable-thread-system=posix" "--enable-dynamic-tls"
    "--enable-openssl"
  ];

  buildInputs = [ openssl ];

  meta = {
    description = "Optimizing Scheme to C compiler";
    homepage    = "http://gambitscheme.org";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin ];
  };
}
