{stdenv, fetchurl, openssl, libmilter, libbsd}:

stdenv.mkDerivation rec {
  name = "opendkim-2.10.3";
  src = fetchurl {
    url = "mirror://sourceforge/opendkim/files/${name}.tar.gz";
    sha256 = "06v8bqhh604sz9rh5bvw278issrwjgc4h1wx2pz9a84lpxbvm823";
  };

  configureFlags="--with-openssl=${openssl} --with-milter=${libmilter}";

  buildInputs = [openssl libmilter libbsd];
  
  meta = {
    description = "C library for producing DKIM-aware applications and an open source milter for providing DKIM service";
    homepage = http://opendkim.org/;
    maintainers = [ ];
    platforms = with stdenv.lib.platforms; all;
  };

}
