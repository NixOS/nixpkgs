{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hatchling,
  aenum,
  aiohttp,
  prompt-toolkit,
  pygments,
  nbformat,
  jupyter-client,
  typing-extensions,
  fastjsonschema,
  platformdirs,
  pyperclip,
  imagesize,
  markdown-it-py,
  linkify-it-py,
  mdit-py-plugins,
  flatlatex,
  timg,
  pillow,
  sixelcrop,
  universal-pathlib,
  fsspec,
  jupytext,
  ipykernel,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  python-magic,
  html2text,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "euporie";
  version = "2.8.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joouha";
    repo = "euporie";
    tag = "v${version}";
    hash = "sha256-T+Zec5vb+y5qf7Xvv+QtVG+olnv2C0933tCJbEQAJuU=";
  };

  build-system = [
    setuptools
    hatchling
  ];

  dependencies = [
    aenum
    aiohttp
    prompt-toolkit
    pygments
    nbformat
    jupyter-client
    typing-extensions
    fastjsonschema
    platformdirs
    pyperclip
    imagesize
    markdown-it-py
    linkify-it-py
    mdit-py-plugins
    flatlatex
    timg
    pillow
    sixelcrop
    universal-pathlib
    fsspec
    jupytext
    ipykernel
  ];

  pythonRelaxDeps = [
    "aenum"
    "linkify-it-py"
    "markdown-it-py"
    "mdit-py-plugins"
    "platformdirs"
  ];

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    python-magic
    html2text
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Jupyter notebooks in the terminal";
    longDescription = ''
      Similar to `jupyter lab` or `jupyter notebook`, This package
      can only be used inside a python environment. To quickly summon
      a python environment with euporie, you can use:
      ```
      nix-shell -p 'python3.withPackages (ps: with ps; [ euporie ])'
      ```
    '';
    homepage = "https://euporie.readthedocs.io/";
    license = lib.licenses.mit;
    mainProgram = "euporie";
    maintainers = with lib.maintainers; [
      euxane
      renesat
    ];
  };
}
