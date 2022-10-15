{ lib
, stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "miniaudio";
  version = "unstable-2020-04-20";

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "miniaudio";
    rev = "4d813cfe23c28db165cce6785419fee9d2399766";
    sha256 = "sha256-efZLZTmkLtvcysd25olDE/QqunU5YTYwSVmUZXPKGIY=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';

  meta = with lib; {
    description = "Single header audio playback and capture library written in C.";
    homepage = "https://github.com/mackron/miniaudio";
    license = licenses.unlicense;
    maintainers = [ maintainers.jansol ];
    platforms = platforms.all;
  };
}
