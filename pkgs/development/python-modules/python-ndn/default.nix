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

buildPythonPackage rec {
  pname = "python-ndn";
  version = "0.5.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "named-data";
    repo = "python-ndn";
    tag = "v${version}";
    hash = "sha256-STn1QnU1spxsACXjWGkGa18Rnqc7yC4NIgWkECA0wnA=";
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
    changelog = "https://github.com/named-data/python-ndn/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
