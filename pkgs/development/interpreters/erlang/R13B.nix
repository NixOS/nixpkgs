{ stdenv, fetchurl, perl, gnum4, ncurses, openssl }:

let version = "R13B"; in

stdenv.mkDerivation {
  name = "erlang-" + version;
  
  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_" + version + ".tar.gz";
    sha256 = "112889v9axhrk9x9swcgql5kpj19p14504m06h4n7b99irzxf4rg";
  };
  
  buildInputs = [ perl gnum4 ncurses openssl ];
  
  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';
  
  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';
  
  configureFlags = "--with-ssl=${openssl}";
}
