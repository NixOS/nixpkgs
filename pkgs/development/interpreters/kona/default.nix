{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kona";
  version = "20211225";

  src = fetchFromGitHub {
    owner = "kevinlawler";
    repo = "kona";
    rev = "Win64-${version}";
    sha256 = "sha256-m3a9conyKN0qHSSAG8zAb3kx8ir+7dqgxm1XGjCQcfk=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  preInstall = ''mkdir -p "$out/bin"'';

  meta = with lib; {
    description = "An interpreter of K, APL-like programming language";
    homepage = "https://github.com/kevinlawler/kona/";
    maintainers = with maintainers; [ raskin ];
    mainProgram = "k";
    platforms = platforms.all;
    license = licenses.isc;
  };
}
