{ lib, stdenv, fetchFromGitHub, cmake, ninja }:

stdenv.mkDerivation rec {
  pname = "nng";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    rev = "v${version}";
    sha256 = "sha256-qbjMLpPk5FxH710Mf8AIraY0mERbaxVVhTT94W0EV+k=";
  };

  nativeBuildInputs = [ cmake ninja ];

  cmakeFlags = [ "-G Ninja" ];

  meta = with lib; {
    homepage = "https://nng.nanomsg.org/";
    description = "Nanomsg next generation";
    license = licenses.mit;
    mainProgram = "nngcat";
    platforms = platforms.unix;
  };
}
