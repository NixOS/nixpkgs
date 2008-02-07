args: with args;

stdenv.mkDerivation {
  name = "erlang-" + version;
  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_" + version + ".tar.gz";
    sha256 = "16w7snhbjzwiywppsp04yiy2bkncff8pf4i643kqzkqx578jhaqz";
  };
  buildInputs = [perl gnum4 ncurses openssl];
  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';
  configureFlags = "--with-ssl=${openssl}";
}
