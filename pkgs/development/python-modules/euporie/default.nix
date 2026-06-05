{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  setuptools,

  # dependencies
  aenum,
  aiohttp,
  fastjsonschema,
  flatlatex,
  fsspec,
  imagesize,
  ipykernel,
  jupyter-client,
  jupytext,
  linkify-it-py,
  markdown-it-py,
  mdit-py-plugins,
  nbformat,
  pillow,
  platformdirs,
  prompt-toolkit,
  pygments,
  pyperclip,
  python-code-minimap,
  sixelcrop,
  timg,
  typing-extensions,
  universal-pathlib,

  # tests
  html2text,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-magic,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "euporie";
  version = "2.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joouha";
    repo = "euporie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JzCVpI1O+KM+V4fLw+vwAsFbUK5SXZvAZWffzojU0u0=";
  };

  build-system = [
    hatchling
    setuptools
  ];

  pythonRelaxDeps = [
    "markdown-it-py"
    "mdit-py-plugins"
    "platformdirs"
    "universal-pathlib"
  ];
  dependencies = [
    aenum
    aiohttp
    fastjsonschema
    flatlatex
    fsspec
    imagesize
    ipykernel
    jupyter-client
    jupytext
    linkify-it-py
    markdown-it-py
    mdit-py-plugins
    nbformat
    pillow
    platformdirs
    prompt-toolkit
    pygments
    pyperclip
    python-code-minimap
    sixelcrop
    timg
    typing-extensions
    universal-pathlib
  ];

  nativeCheckInputs = [
    html2text
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    python-magic
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
    downloadPage = "https://github.com/joouha/euporie";
    changelog = "https://github.com/joouha/euporie/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    mainProgram = "euporie";
    maintainers = with lib.maintainers; [
      euxane
      renesat
    ];
  };
})
