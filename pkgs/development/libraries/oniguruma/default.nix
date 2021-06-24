{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "onig";
  version = "6.9.6";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "0y0dv6axvjjzi9367xc4q2nvvx58919iyzy25d5022lpz9z569kj";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/kkos/oniguruma";
    description = "Regular expressions library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
