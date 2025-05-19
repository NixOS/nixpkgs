{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXinerama,
  libXcursor,
}:

stdenv.mkDerivation rec {
  pname = "sxwm";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "uint23";
    repo = "sxwm";
    rev = "v${version}";
    sha256 = "sha256-CMqVAHrW5oluTmB/DHg65wf8NCSX5fksH/L+GQXZV+o=";
  };

  buildInputs = [
    libX11
    libXinerama
    libXcursor
  ];

  installPhase = "make install PREFIX=$out";

  meta = with lib; {
    homepage = "https://github.com/uint23/sxwm";
    description = "Minimal. Fast. Configurable. Tiling Window Manager for X11";
    license = licenses.mit;
    maintainers = [ maintainers.Xano-verse ];
    platforms = platforms.unix;
  };
}
