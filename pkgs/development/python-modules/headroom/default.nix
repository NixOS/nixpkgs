{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libiconv,
  onnxruntime,

  # build-system
  cffi,

  # dependencies
  click,
  fastapi,
  h2,
  httpx,
  litellm,
  opentelemetry-api,
  pydantic,
  rich,
  tiktoken,
  uvicorn,
  ast-grep-cli,
  tomli,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "headroom-ai";
  version = "0.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chopratejas";
    repo = "headroom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-765aekIjf9oMdY7prRT2CqeDGtXEEDQn43GQkaTeAaY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-WQBvil0bsS6/Z6b+uRauwOQq4VZ57VwAoghcyFdVgLE=";
  };

  postPatch = ''
    substituteInPlace crates/headroom-core/Cargo.toml \
      --replace-fail '"ort-download-binaries-rustls-tls"' '"ort-load-dynamic"'
    substituteInPlace headroom/cli/wrap.py \
      --replace-fail \
        '[sys.executable, "-m", "headroom.cli", "proxy",' \
        '["headroom", "proxy",'
  '';

  nativeBuildInputs = [
    cffi
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [ onnxruntime ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  env = {
    ORT_DYLIB_PATH = "${onnxruntime}/lib/libonnxruntime${stdenv.hostPlatform.extensions.sharedLibrary}";
  };

  propagatedBuildInputs = [
    ast-grep-cli
    click
    fastapi
    h2
    httpx
    litellm
    opentelemetry-api
    pydantic
    rich
    tiktoken
    uvicorn
  ]
  ++ lib.optionals (lib.versionOlder "3.11" finalAttrs.pythonVersion or "3.11") [ tomli ];

  pythonRelaxDeps = [ "litellm" ];

  doCheck = false;

  pythonImportsCheck = [ "headroom" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Context compression layer for LLM applications — 60–95% fewer tokens";
    homepage = "https://github.com/chopratejas/headroom";
    changelog = "https://github.com/chopratejas/headroom/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ch4s3r ];
    mainProgram = "headroom";
    platforms = lib.platforms.unix;
  };
})
