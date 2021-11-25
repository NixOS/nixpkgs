{ lib, stdenv, fetchurl, autoreconfHook, glib, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.3";
  pname = "libsmf";
  src = fetchurl {
    url = "https://github.com/stump/libsmf/archive/${pname}-${version}.tar.gz";
    sha256 = "1527pcc1vd0l5iks2yw8m0bymcrnih2md5465lwpzw0wgy4rky7n";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ glib ];

  meta = with lib; {
    description = "A C library for reading and writing Standard MIDI Files";
    homepage = "https://github.com/stump/libsmf";
    license = licenses.bsd2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
