{stdenv, fetchurl, openssl, libmilter}:

stdenv.mkDerivation rec {
  name = "opendkim-2.4.2";
  src = fetchurl {
    url = "mirror://sourceforge/opendkim/files/${name}.tar.gz";
    sha256 = "0gwgcrnl5c60sxb9z38ari2gl7vd626r3z3dcq8a6aw28pw9w2lk";
  };

  configureFlags="--with-openssl=${openssl} --with-milter=${libmilter}";

  buildInputs = [openssl libmilter];
}
