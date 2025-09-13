{
  lib,
  buildPythonPackage,
  fetchPypi,
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
}:

buildPythonPackage rec {
  pname = "euporie";
  version = "2.8.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mso1pPbiiqFZGthqABnXwZXUGCdLObr8/JRPoh3XZOI=";
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

  meta = {
    description = "Jupyter notebooks in the terminal";
    homepage = "https://euporie.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      euxane
      renesat
    ];
  };
}
