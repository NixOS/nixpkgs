{ lib
, stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "miniaudio";
  version = "0.11.18";

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "miniaudio";
    rev = version;
    hash = "sha256-y0o33hnKoZ8gWWFNFIOUJcXMWENaYzMLZzeTOoVETOY=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';

  meta = with lib; {
    description = "Single header audio playback and capture library written in C";
    homepage = "https://github.com/mackron/miniaudio";
    changelog = "https://github.com/mackron/miniaudio/blob/${src.rev}/CHANGES.md";
    license = with licenses; [ unlicense /* or */ mit0 ];
    maintainers = [ maintainers.jansol ];
    platforms = platforms.all;
  };
}
