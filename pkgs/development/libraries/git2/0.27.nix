{ stdenv, fetchFromGitHub, cmake, pkgconfig, python
, zlib, libssh2, openssl, http-parser, curl
, libiconv, Security
}:

stdenv.mkDerivation rec {
  version = "0.27.8";
  name = "libgit2-${version}";

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "0wzx8nkyy9m7mx6cks58chjd4289vjsw97mxm9w6f1ggqsfnmbr9";
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
