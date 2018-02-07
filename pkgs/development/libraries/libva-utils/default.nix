{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig
, libdrm, libva
}:

stdenv.mkDerivation rec {
  name = "libva-utils-${version}";
  inherit (libva) version;

  src = fetchFromGitHub {
    owner  = "01org";
    repo   = "libva-utils";
    rev    = version;
    sha256 = "02n51cvp8bzzjk4fargwvgh7z71y8spg24hqgaawbp3p3ahh7xxi";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libdrm libva ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "VAAPI tools: Video Acceleration API";
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
    platforms = platforms.unix;
  };
}
