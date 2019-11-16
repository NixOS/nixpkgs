{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "quickjs";
  version = "2019-10-27";

  src = fetchurl {
    url = "https://bellard.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0xm16ja3c0k80jy0xkx0f40r44v2lgx2si4dnaw2w7c5nx7cmkai";
  };

  makeFlags = [ "prefix=${placeholder ''out''}" ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A small and embeddable Javascript engine";
    homepage = "https://bellard.org/quickjs/";
    maintainers = with maintainers; [ stesie ivan ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
