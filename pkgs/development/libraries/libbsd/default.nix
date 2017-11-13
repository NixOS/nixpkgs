{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libbsd-${version}";
  version = "0.8.6";

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "11wnkzims5grprvhb1ssmq9pc2lcgh2r2rk8gwgz36ply6fvyzs6";
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
    maintainers = with maintainers; [ matthewbauer ];
  };
}
