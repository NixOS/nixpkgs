{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "chicken-4.8.1";

  meta = {
    homepage = http://www.call-cc.org/;
    description = "Chicken Scheme";
  };

  src = fetchurl {
    url = http://code.call-cc.org/dev-snapshots/2013/01/04/chicken-4.8.1.tar.gz;
    md5 = "bd758ec7abeaeb4f4c92c290fb5f3db7";
  };

  buildFlags = "PLATFORM=linux PREFIX=$(out) VARDIR=$(out)/var/lib";
  installFlags = "PLATFORM=linux PREFIX=$(out) VARDIR=$(out)/var/lib";
}
