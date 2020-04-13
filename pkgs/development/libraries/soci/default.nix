{ cmake
, fetchFromGitHub
, sqlite
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "soci";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "SOCI";
    repo = pname;
    rev = version;
    sha256 = "06faswdxd2frqr9xnx6bxc7zwarlzsbdi3bqpz7kwdxsjvq41rnb";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DSOCI_STATIC=OFF" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sqlite ];

  meta = with stdenv.lib; {
    description = "Database access library for C++";
    homepage = "http://soci.sourceforge.net/";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
