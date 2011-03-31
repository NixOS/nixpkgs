{ stdenv, fetchurl, perl, gnum4, ncurses, openssl }:

let version = "R14B02"; in

stdenv.mkDerivation {
  name = "erlang-" + version;
  
  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_" + version + ".tar.gz";
    sha256 = "1g85a85w031jr5pmz9b0x3p11d44glkf7qpy64l9y7l2b45hb7c4";
  };
  
  buildInputs = [ perl gnum4 ncurses openssl ];
  
  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';
  
  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';
  
  configureFlags = "--with-ssl=${openssl}";
}
