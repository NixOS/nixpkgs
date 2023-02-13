{ lib
, stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "miniaudio";
  version = "0.11.11";

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "miniaudio";
    rev = "a0dc1037f99a643ff5fad7272cd3d6461f2d63fa";
    # upstream does not maintain tags:
    # https://github.com/mackron/miniaudio/issues/273#issuecomment-783861269
    hash = "sha256-jOvDZk76hDvZ1RQ9O34kVeW0n95BT9+BE6fNhdekI5s=";
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
