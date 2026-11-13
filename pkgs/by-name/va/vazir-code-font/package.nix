{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vazir-code-font";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "vazir-code-font";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iBojse3eHr4ucZtPfpkN+mmO6sEExY8WcAallyPgMsI=";
  };
  outputs = [
    "out"
    "webfont"
  ];
  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/rastikerdar/vazir-code-font";
    description = "Persian (farsi) Monospaced Font for coding";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.dearrude ];
  };
})
