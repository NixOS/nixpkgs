{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "sonivox";
  version = "3.6.12";

  src = fetchFromGitHub {
    owner = "pedrolcl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-df3EwscTF9n1fazz5Oa3FIXgWXHruhJBzMt8Y+ELP94=";
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
