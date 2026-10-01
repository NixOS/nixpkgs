{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  yq-go,
  python3Packages,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "yanone-kaffeesatz";
  version = "2.003-unstable-2023-12-13";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "yanone";
    repo = "kaffeesatz";
    rev = "104c0ced99e8390bf5b138c5ca6065c0f5fcc333";
    hash = "sha256-iOTehvcM4RdDz0HF4AW6mOjOGfAa40HeuwUo847Ph1M=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    yq-go
    installFonts
    python3Packages.fontmake
    python3Packages.fontbakery
    python3Packages.gftools
  ];

  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  # Patch out references to venv and 'venv' make target to avoid a bunch of warnings
  # So the underlying 'venv/touchfile' is never run
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "venv: venv/touchfile" "" \
      --replace-fail "build.stamp: venv" "build.stamp:" \
      --replace-fail "test: venv build.stamp" "test: build.stamp" \
      --replace-fail "proof: venv build.stamp" "proof: build.stamp" \
      --replace-fail ". venv/bin/activate; " ""
  '';

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    description = "Free font classic";
    maintainers = with lib.maintainers; [
      mt-caret
      pancaek
    ];
    platforms = with lib.platforms; all;
    homepage = "https://yanone.de";
    license = lib.licenses.ofl;
  };
}
