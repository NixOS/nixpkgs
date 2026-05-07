{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  uv-build,
}:
buildPythonPackage (finalAttrs: {
  pname = "oinker";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "major";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-jDQKTllteOL30mY089URl/36hY3f5KzSFPNubqnd0d8=";
  };

  build-system = [ uv-build ];

  dependencies = [ httpx ];

  pythonImportsCheck = [ finalAttrs.pname ];

  meta = {
    description = "Pythonic client library for Porkbun DNS";
    mainProgram = finalAttrs.pname;
    homepage = "https://major.github.io/oinker";
    changelog = "https://github.com/major/${finalAttrs.pname}/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
  };
})
