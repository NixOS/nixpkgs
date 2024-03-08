{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "oniguruma";
  version = "6.9.9";

  # Note: do not use fetchpatch or fetchFromGitHub to keep this package available in __bootPackages
  src = fetchurl {
    url = "https://github.com/kkos/oniguruma/releases/download/v${version}/onig-${version}.tar.gz";
    sha256 = "sha256-YBYr07n8b0iG1MegeSX/03QWdzL1Xc6MSRv9nNgYps8=";
  };

  outputs = [ "dev" "lib" "out" ];
  outputBin = "dev"; # onig-config

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = [ "--enable-posix-api=yes" ];

  meta = with lib; {
    homepage = "https://github.com/kkos/oniguruma";
    description = "Regular expressions library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.unix;
  };
}
