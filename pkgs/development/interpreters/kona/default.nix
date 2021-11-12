{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kona";
  version = "20201009";

  src = fetchFromGitHub {
    owner = "kevinlawler";
    repo = "kona";
    rev = "Win64-${version}";
    sha256 = "0v252zds61y01cf29hxznz1zc1724vxmzy059k9jiri4r73k679v";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  preInstall = ''mkdir -p "$out/bin"'';

  meta = with lib; {
    description = "An interpreter of K, APL-like programming language";
    homepage = "https://github.com/kevinlawler/kona/";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
    license = licenses.isc;
  };
}
