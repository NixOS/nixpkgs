{ stdenv, fetchFromGitHub, cmake, pkgconfig, python3
, zlib, libssh2, openssl, pcre, http-parser
, libiconv, Security
}:

stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "1.0.0";
  # keep the version in sync with python3.pkgs.pygit2 and libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "06cwrw93ycpfb5kisnsa5nsy95pm11dbh0vvdjg1jn25h9q5d3vc";
  };

  cmakeFlags = [
    "-DTHREADSAFE=ON"
    "-DUSE_HTTP_PARSER=system"
  ];

  nativeBuildInputs = [ cmake python3 pkgconfig ];

  buildInputs = [ zlib libssh2 openssl pcre http-parser ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = stdenv.lib.optional (!stdenv.isLinux) libiconv;

  enableParallelBuilding = true;

  doCheck = false; # hangs. or very expensive?

  meta = {
    description = "The Git linkable library";
    homepage = "https://libgit2.github.com/";
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; all;
  };
}
