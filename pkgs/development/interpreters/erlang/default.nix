{ stdenv, fetchurl, perl, gnum4, ncurses, openssl
, wxSupport ? false, mesa ? null, wxGTK ? null, xlibs ? null }:

assert wxSupport -> mesa != null && wxGTK != null && xlibs != null;

let version = "R15B01"; in

stdenv.mkDerivation {
  name = "erlang-" + version;
  
  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_" + version + ".tar.gz";
    sha256 = "1pmb3hk51p6dwsspxx40qs7gjfyhxjjc3290qk6w1wwa6bkpskzr";
  };
  
  buildInputs = 
    [ perl gnum4 ncurses openssl
    ] ++ stdenv.lib.optional wxSupport [ mesa wxGTK xlibs.libX11 ];
  
  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';
  
  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';
  
  configureFlags = "--with-ssl=${openssl}";
}
