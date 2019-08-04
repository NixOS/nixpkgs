{ stdenv, fetchFromGitHub, cmake, pkgconfig, python
, zlib, libssh2, openssl, http-parser, curl
, libiconv, Security
}:

stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "0.28.2";
  # keep the version in sync with pythonPackages.pygit2 and libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "0cm8fvs05rj0baigs2133q5a0sm3pa234y8h6hmwhl2bz9xq3k4b";
  };

  cmakeFlags = [ "-DTHREADSAFE=ON" ];

  nativeBuildInputs = [ cmake python pkgconfig ];

  buildInputs = [ zlib libssh2 openssl http-parser curl ]
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
