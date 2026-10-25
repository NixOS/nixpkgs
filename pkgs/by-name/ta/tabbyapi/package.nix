{
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "tabbyapi";
  version = "0-unstable-2026-10-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theroyallab";
    repo = "tabbyAPI";
    rev = "2636ef602b55b5343cf3740dd55a77f21e0a8003";
    hash = "sha256-oQnM8aYLbqwdjJOQ2l3R8iyrv5tCZrMNRjy6rwQYQTI=";
  };

  build-system = with python3Packages; [
    packaging
    setuptools
    wheel
  ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  dependencies =
    with python3Packages;
    [
      fastapi # fastapi-slim
      pydantic
      ruamel-yaml
      rich
      uvicorn
      jinja2
      loguru
      sse-starlette
      packaging
      tokenizers
      numpy
      aiofiles
      aiohttp
      async-lru
      huggingface-hub
      psutil
      httptools
      pillow
      requests
      setuptools

      exllamav3
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      uvloop
    ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'fastapi-slim' 'fastapi'
  '';

  optional-dependencies = with python3Packages; {
    dev = [
      ruff
    ];
    extras = [
      infinity-emb
      sentence-transformers
    ];
  };

  postInstall = ''
    cp *.py $out/${python3Packages.python.sitePackages}/
    cp -r {common,endpoints,backends,templates} $out/${python3Packages.python.sitePackages}/

    # They are wanted during runtime
    mkdir -p $out/share/tabbyapi
    cp -r sampler_overrides $out/share/tabbyapi/
  '';

  postFixup = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/tabbyapi \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --add-flags "$out/${python3Packages.python.sitePackages}/main.py"
  '';

  passthru = {
    inherit (python3Packages.torch) cudaSupport rocmSupport;
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Official API server for Exllama";
    homepage = "https://github.com/theroyallab/tabbyAPI";
    license = lib.licenses.agpl3Only;
    platforms = [
      "x86_64-windows"
      "x86_64-linux"
    ];
    mainProgram = "tabbyapi";
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
}
