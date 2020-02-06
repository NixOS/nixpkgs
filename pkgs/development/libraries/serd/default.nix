{ stdenv, fetchurl, pkgconfig, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "serd";
  version = "0.30.2";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "00kjjgs5a8r72khgpya14scvl3n58wqwl5927y14z03j25q04ccx";
  };

  nativeBuildInputs = [ pkgconfig python3 wafHook ];

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/serd;
    description = "A lightweight C library for RDF syntax which supports reading and writing Turtle and NTriples";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
