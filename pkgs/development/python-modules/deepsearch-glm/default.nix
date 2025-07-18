{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  cxxopts,
  deepsearch-toolkit,
  docling-core,
  fasttext,
  fmt,
  loguru,
  matplotlib,
  nlohmann_json,
  pandas,
  pcre2,
  pkg-config,
  poetry-core,
  pybind11,
  python-dotenv,
  requests,
  rich,
  sentencepiece,
  tabulate,
  tqdm,
  utf8cpp,
  zlib,
}:

buildPythonPackage rec {
  pname = "deepsearch-glm";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "deepsearch-glm";
    tag = "v${version}";
    hash = "sha256-3sJNkrx0tTm6RMYAwV8Aha7x8dZjf4tGdds8OScRff8=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  build-system = [
    poetry-core
    pybind11
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev utf8cpp}/include/utf8cpp";
    USE_SYSTEM_DEPS = true;
  };

  optional-dependencies = {
    docling = [
      docling-core
      pandas
    ];
    pyplot = [
      matplotlib
    ];
    toolkit = [
      deepsearch-toolkit
      python-dotenv
    ];
    utils = [
      pandas
      python-dotenv
      requests
      rich
      tabulate
      tqdm
    ];
  };

  buildInputs = [
    cxxopts
    fasttext
    fmt
    loguru
    nlohmann_json
    pcre2
    sentencepiece
    utf8cpp
    zlib
  ];

  # Test suite insists on downloading models, data etc. from s3 bucket
  doCheck = false;

  pythonImportsCheck = [
    "deepsearch_glm"
  ];

  meta = {
    changelog = "https://github.com/DS4SD/deepsearch-glm/releases/tag/v${version}";
    description = "Create fast graph language models from converted PDF documents for knowledge extraction and Q&A";
    homepage = "https://github.com/DS4SD/deepsearch-glm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booxter ];
  };
}
