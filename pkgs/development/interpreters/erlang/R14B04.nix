{ stdenv, fetchurl, perl, gnum4, ncurses, openssl }:

let version = "R14B04"; in

stdenv.mkDerivation {
  name = "erlang-" + version;
  
  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_" + version + ".tar.gz";
    sha256 = "0vlvjlg8vzcy6inb4vj00bnj0aarvpchzxwhmi492nv31s8kb6q9";
  };
  
  buildInputs = [ perl gnum4 ncurses openssl ];
  
  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';
  
  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';
  
  configureFlags = "--with-ssl=${openssl}";
}
