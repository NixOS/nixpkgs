{ stdenv, fetchFromGitHub, cmake, pkgconfig, python3
, zlib, libssh2, openssl, http-parser
, libiconv, Security
}:

stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "0.28.4";
  # keep the version in sync with python3.pkgs.pygit2 and libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "171b25aym4q88bidc4c76y4l6jmdwifm3q9zjqsll0wjhlkycfy1";
  };

  cmakeFlags = [ "-DTHREADSAFE=ON" ];

  nativeBuildInputs = [ cmake python3 pkgconfig ];

  buildInputs = [ zlib libssh2 openssl http-parser ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = stdenv.lib.optional (!stdenv.isLinux) libiconv;

  enableParallelBuilding = true;

  doCheck = false; # hangs. or very expensive?

  meta = {
    description = "The Git linkable library";
    homepage = https://libgit2.github.com/;
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; all;
  };
}
