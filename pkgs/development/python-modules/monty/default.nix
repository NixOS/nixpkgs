{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  numpy,
  ruamel-yaml,

  # optional-dependencies
  invoke,
  ipython,
  msgpack,
  myst-parser,
  orjson,
  pandas,
  pint,
  pydantic,
  pymongo,
  requests,
  roman-numerals,
  sphinx,
  sphinx-markdown-builder,
  sphinx-rtd-theme,
  torch,
  tqdm,

  # tests
  pytestCheckHook,
  pytest-benchmark,
}:

buildPythonPackage (finalAttrs: {
  pname = "monty";
  version = "2026.7.16";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "materialyzeai";
    repo = "monty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x5FNw7E3rtrgCWVhMsBpnO+uwu+mB3ELNFdd33+uFds=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    ruamel-yaml
  ];

  optional-dependencies = rec {
    dev = [ ipython ];
    docs = [
      sphinx
      sphinx-rtd-theme
      requests
      invoke
      myst-parser
      sphinx-markdown-builder
      roman-numerals
    ];
    json = [
      orjson
      pandas
      pint
      pydantic
      pymongo
      torch
    ];
    multiprocessing = [ tqdm ];
    optional = dev ++ json ++ multiprocessing ++ serialization;
    serialization = [ msgpack ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
  ]
  ++ finalAttrs.passthru.optional-dependencies.optional;

  pythonImportsCheck = [ "monty" ];

  meta = {
    description = "Serves as a complement to the Python standard library by providing a suite of tools to solve many common problems";
    longDescription = "
      Monty implements supplementary useful functions for Python that are not part of the
      standard library. Examples include useful utilities like transparent support for zipped files, useful design
      patterns such as singleton and cached_class, and many more.
    ";
    homepage = "https://github.com/materialyzeai/monty";
    changelog = "https://github.com/materialyzeai/monty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      psyanticy
      berquist
    ];
  };
})
