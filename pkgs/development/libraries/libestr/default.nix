{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libestr-0.1.10";

  src = fetchurl {
    url = "http://libestr.adiscon.com/files/download/${name}.tar.gz";
    sha256 = "0g3hmh3wxgjbn5g6cgy2l0ja806jd0ayp22bahcds3kmdq95wrdx";
  };

  meta = with stdenv.lib; {
    homepage = http://libestr.adiscon.com/;
    description = "Some essentials for string handling";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
