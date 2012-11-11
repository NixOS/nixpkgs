{ stdenv, fetchurl, perl, gnum4, ncurses, openssl
, wxSupport ? false, mesa ? null, wxGTK ? null, xlibs ? null }:

assert wxSupport -> mesa != null && wxGTK != null && xlibs != null;

let version = "R15B02"; in

stdenv.mkDerivation {
  name = "erlang-" + version;
  
  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_" + version + ".tar.gz";
    sha256 = "03eb0bd640916666ff83df1330912225fbf555e0c8cf58bb35d8307a314f1158";
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
