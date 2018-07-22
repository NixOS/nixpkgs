{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libdrm, libva
}:

stdenv.mkDerivation rec {
  name = "libva-utils-${version}";
  inherit (libva) version;

  src = fetchFromGitHub {
    owner  = "01org";
    repo   = "libva-utils";
    rev    = version;
    sha256 = "113wdmi4r0qligizj9zmd4a8ml1996x9g2zp2i4pmhb8frv9m8j2";
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
