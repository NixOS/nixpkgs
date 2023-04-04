{ lib
, stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "miniaudio";
  version = "0.11.14";

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "miniaudio";
    rev = "9a7663496fc06f7a9439c752fd7666ca93328c20";
    # upstream does not maintain tags:
    # https://github.com/mackron/miniaudio/issues/273#issuecomment-783861269
    hash = "sha256-v/Eo4/CYcpB4tbOoy1gPqk6PUvkQIZNWrweG3l5EcMk=";
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
