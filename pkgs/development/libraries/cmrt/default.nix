{ stdenv, fetchurl, autoreconfHook, pkgconfig, libdrm, libva }:

stdenv.mkDerivation rec {
  name = "cmrt-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "https://github.com/intel/cmrt/archive/${version}.tar.gz";
    sha256 = "1q7651nvvcqhph5rgfhklm71zqd0c405mrh3wx0cfzvil82yj8na";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libdrm libva ];

  meta = with stdenv.lib; {
    homepage = https://01.org/linuxmedia;
    description = "Intel C for Media Runtime";
    longDescription = "Media GPU kernel manager for Intel G45 & HD Graphics family";
    license = licenses.mit;
    maintainers = with maintainers; [ tadfisher ];
    platforms = platforms.linux;
  };
}
