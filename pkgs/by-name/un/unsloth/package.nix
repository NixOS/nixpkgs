{
  lib,
  fetchFromGitHub,
  python3,
  buildNpmPackage,
  nodejs_22,
  cudaPackages,
  gcc,
  llama-cpp,
}:

let
  pname = "unsloth";
  version = "2026.4.8";

  src = fetchFromGitHub {
    owner = "unslothai";
    repo = "unsloth";
    rev = "b09aa82a3ac9ac9794c497e4b8f747f77e52b162";
    hash = "sha256-Vm3RLtB0FumkI3EnhcMi+IUPsvAg8hYOyRRi1R/9uYw=";
  };

  studio-frontend = buildNpmPackage {
    pname = "${pname}-studio-frontend";
    inherit version src;

    sourceRoot = "${src.name}/studio/frontend";

    # Upstream ships no lockfile; one was generated and committed alongside
    # this package. Inject it before npmConfigHook tries to use it.
    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';

    nodejs = nodejs_22;

    npmDepsHash = "sha256-bgF/0eCMzYy5NWwmLBO2ju1xHzjEOmKUHiB9XfPhn8A=";

    # Skip the typecheck step from `npm run build` since the frontend ships
    # with type errors that aren't relevant to the bundled output.
    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };
in
python3.pkgs.buildPythonApplication {
  inherit pname version src;
  pyproject = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["setuptools==80.9.0", "setuptools-scm==9.2.0"]' \
                     'requires = ["setuptools", "setuptools-scm"]'

    # Upstream's datasets guard says only 4.4.0 and 4.4.1 recurse, but the
    # current check blocks the whole 4.4.0 .. 4.5.0 range. Narrow it to the
    # versions the upstream comment actually calls out.
    substituteInPlace unsloth/import_fixes.py \
      --replace-fail 'if (datasets_version <= Version("4.5.0")) and (' \
                     'if (datasets_version <= Version("4.4.1")) and ('

    # Drop the file with parens/spaces in its name -- it confuses
    # setuptools' package-data globbing on some platforms and is unused.
    rm -f 'studio/frontend/data-designer.openapi (1).yaml'

    # Inject the prebuilt studio frontend bundle (Tauri/React/Vite app)
    # so `unsloth studio` can serve it as static assets.
    mkdir -p studio/frontend/dist
    cp -r ${studio-frontend}/. studio/frontend/dist/

    # Skip the install.sh venv re-exec dance in `unsloth studio` and
    # `unsloth studio run`. Nix installs studio.backend.* into the same
    # site-packages as the CLI, so we can import directly. Both functions
    # share the exact same probe line; force it to True everywhere.
    sed -i \
      's|in_studio_venv = sys.prefix.startswith(str(studio_venv_dir))|in_studio_venv = True  # Nix install: studio.backend is already importable|g' \
      unsloth_cli/commands/studio.py
  '';

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    # Core unsloth runtime (the [huggingface] extras in pyproject.toml,
    # kept as hard deps so the library is usable out of the box)
    bitsandbytes
    numpy
    packaging
    psutil
    torch
    unsloth-zoo
    xformers
    tyro
    transformers
    datasets
    sentencepiece
    tqdm
    accelerate
    trl
    peft
    protobuf
    huggingface-hub
    hf-transfer
    diffusers
    torchvision

    # CLI + studio backend (required to import unsloth_cli and
    # studio.backend.core, which `unsloth inference` / `unsloth export` /
    # `unsloth studio` use)
    typer
    pydantic
    pyyaml
    nest-asyncio
    fastapi
    uvicorn
    starlette
    python-multipart
    structlog
    pyjwt
    httpx
    requests
    matplotlib
    pandas
    easydict
    addict
    ddgs
    diceware
  ];

  # pyproject.toml pins obsolete versions for several runtime deps.
  pythonRelaxDeps = [
    "datasets"
    "protobuf"
    "transformers"
    "torch"
  ];

  # Upstream lists a build-only dep as a runtime requirement.
  pythonRemoveDeps = [
    "wheel"
  ];

  doCheck = false;

  # Importing requires a GPU, else:
  # NotImplementedError: Unsloth: No NVIDIA GPU found?
  dontUsePythonImportsCheck = true;

  # Studio's GGUF backend probes LLAMA_SERVER_PATH first, then falls
  # back to ~/.unsloth/llama.cpp (which only exists after install.sh).
  # Point it at the Nix-built binary so `unsloth studio` can load
  # GGUF models without the user-side build step.
  makeWrapperArgs = [
    "--set-default"
    "LLAMA_SERVER_PATH"
    "${lib.getBin llama-cpp}/bin/llama-server"
  ];

  passthru = {
    inherit studio-frontend;
    tests.cuda =
      # FIXME: Replace python3.pkgs with python3Packages once possible.
      # Cf. https://github.com/NixOS/nixpkgs/pull/394838#issuecomment-3319287038
      cudaPackages.writeGpuTestPython.override
        { python3Packages = python3.pkgs; }
        {
          libraries = ps: [
            ps.unsloth
            ps.unsloth-zoo
          ];
          gpuCheckArgs.meta.broken = true;
        }
        ''
          import os, sys, runpy

          os.environ["CC"]  = "${lib.getExe' gcc "cc"}";
          os.environ["CXX"] = "${lib.getExe' gcc "cxx"}";

          sys.path.insert(0, "${src}")

          runpy.run_path(
              "${src}/tests/qlora/test_unsloth_qlora_train_and_merge.py",
              run_name="__main__"
          )
        '';
  };

  meta = {
    description = "Finetune Llama 3.3, DeepSeek-R1 & Reasoning LLMs 2x faster with 70% less memory (full distribution: library + CLI + Studio)";
    homepage = "https://github.com/unslothai/unsloth";
    # Core unsloth Python library is Apache-2.0; the bundled CLI and
    # Studio backend (unsloth_cli/, studio/) are AGPL-3.0-only.
    license = with lib.licenses; [
      asl20
      agpl3Only
    ];
    mainProgram = "unsloth";
    maintainers = with lib.maintainers; [ hoh ];
  };
}
