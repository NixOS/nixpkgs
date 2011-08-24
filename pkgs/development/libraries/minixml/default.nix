{ stdenv, fetchurl }:

stdenv.mkDerivation  rec {
  name = "mxml-${version}";
  version = "2.6";

  src = fetchurl {
    url = "http://ftp.easysw.com/pub/mxml/${version}/${name}.tar.gz";
    sha256 = "15cpqr43cwvy1ms67rfav8l9fjgybkaqfq7nhag8qnhd3bd4glxh";
  };

  meta = with stdenv.lib; {
    description = "a small XML library";
    homepage = http://www.minixml.org;
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
