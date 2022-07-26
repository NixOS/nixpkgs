{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, fftwFloat}:

stdenv.mkDerivation rec {
  pname = "libspecbleach";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WmUl8rA/+V+hv7FPG/5Or6aAQVqt1rIJtdb53KhSmuo=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    fftwFloat
  ];

  meta = with lib; {
    description = "C library for audio noise reduction";
    homepage    = "https://github.com/lucianodato/libspecbleach";
    license     = licenses.lgpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
