{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tclap-1.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/tclap/${name}.tar.gz";
    sha256 = "1fzf7l1wvlhxnpwi15jvvfizn836s7r0r8vckgbqk2lyf7ihz7wz";
  };

  meta = {
    homepage = http://tclap.sourceforge.net/;
    description = "Templatized C++ Command Line Parser Library";
    platforms = stdenv.lib.platforms.all;
  };
}
