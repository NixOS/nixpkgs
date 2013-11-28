{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "chicken-4.8.2";

  meta = {
    homepage = http://www.call-cc.org/;
    description = "Chicken Scheme";
  };

  src = fetchurl {
    url = http://code.call-cc.org/dev-snapshots/2013/08/08/chicken-4.8.2.tar.gz;
    sha1 = "762cd246b3089fa206bbf74679172b1f5f90c812";
  };

  buildFlags = "PLATFORM=linux PREFIX=$(out) VARDIR=$(out)/var/lib";
  installFlags = "PLATFORM=linux PREFIX=$(out) VARDIR=$(out)/var/lib";
}
