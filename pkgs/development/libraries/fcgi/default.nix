{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fcgi-2.4.0";

  src = fetchurl {
    url = "http://www.fastcgi.com/dist/${name}.tar.gz";
    sha256 = "1f857wnl1d6jfrgfgfpz3zdaj8fch3vr13mnpcpvy8bang34bz36";
  };

  patches = [ ./gcc-4.4.diff ];

  postInstall = "ln -s . $out/include/fastcgi";

  meta = with stdenv.lib; {
    description = "FastCGI  is a language independent, scalable, open extension to CG";
    homepage = http://www.fastcgi.com/;
    license = "FastCGI see LICENSE.TERMS";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
