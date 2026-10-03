{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  installFonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xits-math";
  version = "1.302";

  src = fetchFromGitHub {
    owner = "aliftype";
    repo = "xits";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4SXfV/q5dZx0tdLCvWv3PX7Qki0QJdnQz+lT3wooefQ=";
  };

  nativeBuildInputs =
    (with python3Packages; [
      python
      fonttools
      fontforge
    ])
    ++ [ installFonts ];

  postPatch = ''
    rm *.otf
  '';

  # installFonts adds a hook to `postInstall` that installs fonts
  # into the correct directories
  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/aliftype/xits";
    description = "OpenType implementation of STIX fonts with math support";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
