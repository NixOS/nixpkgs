{
  lib,
  cargo,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  protobuf,
  python3,
  rustc,
  rustPlatform,
  versionCheckHook,

  lspSupport ? true,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # https://github.com/Davidyz/VectorCode/pull/36
      chromadb = super.chromadb.overridePythonAttrs (old: rec {
        version = "0.6.3";
        src = fetchFromGitHub {
          owner = "chroma-core";
          repo = "chroma";
          tag = version;
          hash = "sha256-yvAX8buETsdPvMQmRK5+WFz4fVaGIdNlfhSadtHwU5U=";
        };
        cargoDeps = rustPlatform.fetchCargoVendor {
          pname = "chromadb";
          inherit version src;
          hash = "sha256-lHRBXJa/OFNf4x7afEJw9XcuDveTBIy3XpQ3+19JXn4=";
        };
        postPatch = null;
        build-system = with self; [
          setuptools
          setuptools-scm
        ];
        nativeBuildInputs = [
          cargo
          pkg-config
          protobuf
          rustc
          rustPlatform.cargoSetupHook
        ];
        dependencies = old.dependencies ++ [
          self.chroma-hnswlib
        ];
        doCheck = false;
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "vectorcode";
  version = "0.6.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Davidyz";
    repo = "VectorCode";
    tag = version;
    hash = "sha256-7RI5F7r4yX3wqAuakdBvZOvDRWn8IHntU0fyTPIXjT4=";
  };

  build-system = with python.pkgs; [
    pdm-backend
  ];

  dependencies =
    with python.pkgs;
    [
      chromadb
      colorlog
      httpx
      json5
      numpy
      pathspec
      psutil
      pygments
      sentence-transformers
      shtab
      tabulate
      transformers
      tree-sitter
      tree-sitter-language-pack
    ]
    ++ lib.optionals lspSupport optional-dependencies.lsp;

  optional-dependencies = with python.pkgs; {
    intel = [
      openvino
      optimum
    ];
    legacy = [
      numpy
      torch
      transformers
    ];
    lsp = [
      lsprotocol
      pygls
    ];
    mcp = [
      mcp
      pydantic
    ];
  };

  postInstall = ''
    $out/bin/vectorcode --print-completion=bash >vectorcode.bash
    $out/bin/vectorcode --print-completion=zsh >vectorcode.zsh
    installShellCompletion vectorcode.{bash,zsh}
  '';

  pythonImportsCheck = [ "vectorcode" ];

  nativeCheckInputs =
    [
      installShellFiles
      versionCheckHook
    ]
    ++ (with python.pkgs; [
      mcp
      pygls
      pytestCheckHook
    ]);
  versionCheckProgramArg = "version";

  disabledTests = [
    # Require internet access
    "test_get_embedding_function"
    "test_get_embedding_function_fallback"
    "test_get_reranker"
    "test_supported_rerankers_initialization"
  ];

  meta = {
    description = "Code repository indexing tool to supercharge your LLM experience";
    homepage = "https://github.com/Davidyz/VectorCode";
    changelog = "https://github.com/Davidyz/VectorCode/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "vectorcode";
  };
}
