{ lib, stdenv, fetchFromGitHub, cmake, libuuid }:

stdenv.mkDerivation rec {
  pname = "crossguid";
  version = "unstable-2019-05-29";

  src = fetchFromGitHub {
    owner = "graeme-hill";
    repo = pname;
    rev = "ca1bf4b810e2d188d04cb6286f957008ee1b7681";
    hash = "sha256-37tKPDo4lukl/aaDWWSQYfsBNEnDjE7t6OnEZjBhcvQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional stdenv.isLinux libuuid;

  meta = with lib; {
    description = "Lightweight cross platform C++ GUID/UUID library";
    license = licenses.mit;
    homepage = "https://github.com/graeme-hill/crossguid";
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.unix;
  };
}
