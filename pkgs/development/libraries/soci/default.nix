{ cmake
, fetchFromGitHub
, sqlite
, postgresql
, boost
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "soci";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "SOCI";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NE0ApbX8HG2VAQ9cg9+kX3kJQ4PR1XvWL9BlT8NphmE=";
  };

  # Do not build static libraries
  cmakeFlags = [ "-DSOCI_STATIC=OFF" "-DCMAKE_CXX_STANDARD=11" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    sqlite
    postgresql
    boost
  ];

  meta = with lib; {
    description = "Database access library for C++";
    homepage = "http://soci.sourceforge.net/";
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
