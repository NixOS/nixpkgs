{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "onig";
  version = "6.9.8";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "sha256-8aFZdhh6ovLCR0A17rvWq/Oif66rSMnHcCYHjClNElw=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = [ "--enable-posix-api=yes" ];

  meta = with lib; {
    homepage = "https://github.com/kkos/oniguruma";
    description = "Regular expressions library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
