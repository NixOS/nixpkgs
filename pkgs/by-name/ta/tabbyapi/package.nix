{
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "tabbyapi";
  version = "0-unstable-2026-01-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theroyallab";
    repo = "tabbyAPI";
    rev = "54e3ea1fb30c48217f82dcb4ab1359f4784da4c8";
    hash = "sha256-cwxpW4s8LKxS+2A2Grfhx8XaxbfT8U1LG59yhbu1lD8=";
  };

  build-system = with python3Packages; [
    packaging
    setuptools
    wheel
  ];

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
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
      formatron
      kbnf
      aiofiles
      aiohttp
      async-lru
      huggingface-hub
      psutil
      httptools
      pillow
      numpy
      setuptools

      exllamav2
      exllamav3
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      uvloop
    ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'fastapi-slim' 'fastapi'
  '';

  optional-dependencies = with python3Packages; {
    amd = [
      pytorch-triton-rocm
      torch
    ];
    cu118 = [
      torch
    ];
    cu121 = [
      flash-attn
      torch
    ];
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
  '';

  postFixup = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/tabbyapi \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --add-flags "$out/${python3Packages.python.sitePackages}/main.py"
  '';

  passthru.updateScript = nix-update-script { };

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
