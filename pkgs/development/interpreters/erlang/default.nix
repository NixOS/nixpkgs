{ stdenv, fetchurl, perl, gnum4, ncurses, openssl }:

let version = "R14A"; in

stdenv.mkDerivation {
  name = "erlang-" + version;
  
  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_" + version + ".tar.gz";
    sha256 = "170n5p6al1bxwngdmafm1c6892xjxppb96gzgki9gfb0mla6li73";
  };
  
  buildInputs = [ perl gnum4 ncurses openssl ];
  
  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';
  
  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';
  
  configureFlags = "--with-ssl=${openssl}";
}
