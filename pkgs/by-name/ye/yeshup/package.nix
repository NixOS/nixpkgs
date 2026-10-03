{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "yeshup";
  version = "0-unstable-2013-10-29";

  src = fetchFromGitHub {
    owner = "RhysU";
    repo = "yeshup";
    rev = "5461a8f957c686ccd0240be3f0fd8124d7381b08";
    hash = "sha256-aQcBTUv+MkOMkX+7zvffM+VF26jg0hBb1dIQj0pgi/M=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -v yeshup $out/bin
  '';

  meta = {
    homepage = "https://github.com/RhysU/yeshup";
    platforms = lib.platforms.linux;
    license = lib.licenses.cc-by-sa-30; # From Stackoverflow answer
    maintainers = with lib.maintainers; [ obadz ];
    mainProgram = "yeshup";
  };
}
