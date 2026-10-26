{
  lib,
  aenum,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  poetry-core,
  poetry-dynamic-versioning,
  pycryptodomex,
  pygtrie,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-ndn";
  version = "0.5.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "named-data";
    repo = "python-ndn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8fcBIcZ2l6mkKe9YQe5+5fh7+vK9qxzBO2kLRUONumQ=";
  };

  nativeBuildInputs = [
    setuptools
    poetry-core
  ];

  propagatedBuildInputs = [
    poetry-dynamic-versioning
    pycryptodomex
    lark
    pygtrie
    aenum
    aiohttp
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonRelaxDeps = [ "lark" ];

  pythonImportsCheck = [ "ndn" ];

  meta = {
    description = "NDN client library with AsyncIO support";
    homepage = "https://github.com/named-data/python-ndn";
    changelog = "https://github.com/named-data/python-ndn/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
