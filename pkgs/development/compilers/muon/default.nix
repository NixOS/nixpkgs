{ stdenv, lib, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "muon";
  version = "2019-11-27";

  src = fetchFromGitHub {
    owner = "nickmqb";
    repo = pname;
    rev = "6d3a5054ae75b0e5a0ae633cf8cbc3e2a054f8b3";
    sha256 = "1sb1i08421jxlx791g8nh4l239syaj730hagkzc159g0z65614zz";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    mkdir -p $out/bin $out/share/mu
    cp -r lib $out/share/mu
    gcc -O3 -o $out/bin/mu-unwrapped bootstrap/mu64.c
  '';

  installPhase = ''
    makeWrapper $out/bin/mu-unwrapped $out/bin/mu \
      --add-flags $out/share/mu/lib/core.mu
  '';

  meta = with lib; {
    description = "Modern low-level programming language";
    homepage = "https://github.com/nickmqb/muon";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    platforms = [ "x86_64-linux" ];
  };
}
