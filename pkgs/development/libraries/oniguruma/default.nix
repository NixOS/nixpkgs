{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "onig";
  version = "6.9.7.1";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "sha256-IBWxmzmVdKTkHbfy7V8ejpeIdfOU/adGwpUTCMdLU3w=";
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
