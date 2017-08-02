{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libbsd-${version}";
  version = "0.8.5";

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0a2vq0xdhs3yyj91b0612f19fakg7a9xlqy2f993128kyhjd0ivn";
  };

  # darwin changes configure.ac which means we need to regenerate
  # the configure scripts
  nativeBuildInputs = [ autoreconfHook ];

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./darwin.patch ];

  meta = with stdenv.lib; {
    description = "Common functions found on BSD systems";
    homepage = https://libbsd.freedesktop.org/;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
