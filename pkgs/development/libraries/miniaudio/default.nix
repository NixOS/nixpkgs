{ lib
, stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "miniaudio";
<<<<<<< HEAD
  version = "0.11.17";
=======
  version = "0.11.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mackron";
    repo = "miniaudio";
<<<<<<< HEAD
    rev = version;
    hash = "sha256-nPQ53+9CDEn91LZgF5RkVur+XckTDcS38FHomPXbtMI=";
=======
    rev = "9a7663496fc06f7a9439c752fd7666ca93328c20";
    # upstream does not maintain tags:
    # https://github.com/mackron/miniaudio/issues/273#issuecomment-783861269
    hash = "sha256-v/Eo4/CYcpB4tbOoy1gPqk6PUvkQIZNWrweG3l5EcMk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
