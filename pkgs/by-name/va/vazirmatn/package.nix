{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vazirmatn";
  version = "33.003";

  src = fetchFromGitHub {
    owner = "rastikerdar";
    repo = "vazirmatn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C1UtfrRFzz0uv/hj8e7huXe4sNd5h7ozVhirWEAyXGg=";
  };
  __structuredAttrs = true;
  strictDeps = true;
  dontBuild = true;

  outputs = [
    "out"
    "webfont"
  ];
  nativeBuildInputs = [ installFonts ];

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/rastikerdar/vazirmatn";
    description = "Persian (Farsi) Font - قلم (فونت) فارسی وزیرمتن";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
