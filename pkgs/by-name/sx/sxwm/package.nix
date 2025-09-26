{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXinerama,
  libXcursor,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sxwm";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "uint23";
    repo = "sxwm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CMqVAHrW5oluTmB/DHg65wf8NCSX5fksH/L+GQXZV+o=";
  };

  buildInputs = [
    libX11
    libXinerama
    libXcursor
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/uint23/sxwm";
    changelog = "https://github.com/uint23/sxwm/releases/tag/v${finalAttrs.version}";
    description = "Minimal. Fast. Configurable. Tiling Window Manager for X11";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Xano-verse ];
    platforms = lib.platforms.unix;
  };
})
