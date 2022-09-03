{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, python3
, zlib
, libssh2
, openssl
, pcre
, http-parser
, libiconv
, Security
, staticBuild ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "1.5.0";
  # also check the following packages for updates: python3.pkgs.pygit2 and libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "sha256-lXFQo+tt56BFoPgdkTfz6WdIngeotTm+8cAGcBP6XqY=";
  };

  cmakeFlags = [
    "-DTHREADSAFE=ON"
    "-DUSE_HTTP_PARSER=system"
    "-DUSE_SSH=ON"
    "-DBUILD_SHARED_LIBS=${if staticBuild then "OFF" else "ON"}"
  ];

  nativeBuildInputs = [ cmake python3 pkg-config ];

  buildInputs = [ zlib libssh2 openssl pcre http-parser ]
    ++ lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = lib.optional (!stdenv.isLinux) libiconv;

  doCheck = false; # hangs. or very expensive?

  meta = with lib; {
    description = "Linkable library implementation of Git that you can use in your application";
    homepage = "https://libgit2.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
