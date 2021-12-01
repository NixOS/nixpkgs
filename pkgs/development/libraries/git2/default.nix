{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, python3
, zlib, libssh2, openssl, pcre, http-parser
, libiconv, Security
}:

stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "1.3.0";
  # keep the version in sync with python3.pkgs.pygit2 and libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "sha256-7atNkOBzX+nU1gtFQEaE+EF1L+eex+Ajhq2ocoJY920=";
  };

  cmakeFlags = [
    "-DTHREADSAFE=ON"
    "-DUSE_HTTP_PARSER=system"
  ];

  nativeBuildInputs = [ cmake python3 pkg-config ];

  buildInputs = [ zlib libssh2 openssl pcre http-parser ]
    ++ lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = lib.optional (!stdenv.isLinux) libiconv;

  doCheck = false; # hangs. or very expensive?

  meta = {
    description = "The Git linkable library";
    homepage = "https://libgit2.github.com/";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; all;
  };
}
