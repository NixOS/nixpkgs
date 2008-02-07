args: with args;

stdenv.mkDerivation {
  name = "erlang-" + version;
  src = fetchurl {
    url = http://www.erlang.org/download/otp_src_R11B-5.tar.gz;
    md5 = "96acec41da87d6ee0ef18e1aab36ffdd";
  };
  buildInputs = [perl gnum4 ncurses openssl];
  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';
  configureFlags = "--with-ssl=${openssl}";
}
