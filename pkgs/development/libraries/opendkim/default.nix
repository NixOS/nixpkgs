{stdenv, fetchurl, openssl, libmilter}:

stdenv.mkDerivation rec {
  name = "opendkim-1.2.2";
  src = fetchurl {
    url = "mirror://sourceforge/opendkim/files/${name}.tar.gz";
    sha256 = "01kvhm10kv17mm4zfz0zd24wzr98fxqwyzm56m2l1v262ng3l4nw";
  };

  configureFlags="--with-openssl=${openssl} --with-milter=${libmilter}";

  buildInputs = [openssl libmilter];
}
