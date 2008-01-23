{stdenv, fetchurl, perl, ncurses, gnum4, openssl}:

stdenv.mkDerivation {
  name = "erlang-R11B-5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.erlang.org/download/otp_src_R11B-5.tar.gz;
    md5 = "96acec41da87d6ee0ef18e1aab36ffdd";
  };
  inherit perl ncurses gnum4 openssl;
}
