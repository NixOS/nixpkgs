{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
}:

stdenv.mkDerivation rec {
  pname = "libgit2";
  version = "1.4.0";
  # also check the following packages for updates: python3.pkgs.pygit2 and libgit2-glib

  src = fetchFromGitHub {
    owner = "libgit2";
    repo = "libgit2";
    rev = "v${version}";
    sha256 = "sha256-21t7fD/5O+HIHUDEv8MqloDmAIm9sSpJYqreCD3Co2k=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/libgit2/libgit2/commit/8bc9eda779b2e2602fc74944aba5d39198e0642f.patch";
      sha256 = "sha256-r2i4+WsrxIpSwH0g/AikBdAajBncXb1zz0uOQB0h1Jk=";
    })
  ];

  cmakeFlags = [
    "-DTHREADSAFE=ON"
    "-DUSE_HTTP_PARSER=system"
    "-DUSE_SSH=ON"
  ];

  nativeBuildInputs = [ cmake python3 pkg-config ];

  buildInputs = [ zlib libssh2 openssl pcre http-parser ]
    ++ lib.optional stdenv.isDarwin Security;

  propagatedBuildInputs = lib.optional (!stdenv.isLinux) libiconv;

  doCheck = false; # hangs. or very expensive?

  meta = {
    description = "Linkable library implementation of Git that you can use in your application";
    homepage = "https://libgit2.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ];
  };
}
