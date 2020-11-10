{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libbsd";
  version = "0.10.0";

  src = fetchurl {
    url = "https://libbsd.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "11x8q45jvjvf2dvgclds64mscyg10lva33qinf2hwgc84v3svf1l";
  };

  # darwin changes configure.ac which means we need to regenerate
  # the configure scripts
  nativeBuildInputs = [ autoreconfHook ];

  patches = [ ./darwin.patch ];

  meta = with stdenv.lib; {
    description = "Common functions found on BSD systems";
    homepage = "https://libbsd.freedesktop.org/";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
