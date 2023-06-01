{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "sonivox";
  version = "3.6.11";

  src = fetchFromGitHub {
    owner = "pedrolcl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kCMY9A16g+CNNPn4PZ80QdEP6f58zCI3fQ1BFiK1ZQg=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/pedrolcl/sonivox";
    description = "MIDI synthesizer library";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
