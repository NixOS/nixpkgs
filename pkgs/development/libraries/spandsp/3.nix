{ lib, stdenv, fetchFromGitHub, audiofile, libtiff, autoreconfHook }:
stdenv.mkDerivation rec {
  version = "3.0.0";
  pname = "spandsp";
  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = pname;
    rev = "6ec23e5a7e411a22d59e5678d12c4d2942c4a4b6"; # upstream does not seem to believe in tags
    sha256 = "03w0s99y3zibi5fnvn8lk92dggfgrr0mz5255745jfbz28b2d5y7";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ audiofile libtiff ];

  meta = {
    description = "A portable and modular SIP User-Agent with audio and video support";
    homepage = "https://github.com/freeswitch/spandsp";
    platforms = with lib.platforms; unix;
    maintainers = with lib.maintainers; [ ajs124 misuzu ];
    license = lib.licenses.gpl2;
  };
}
