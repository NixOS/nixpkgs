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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-ndn";
  version = "0.5.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = "python-ndn";
    tag = "v${version}";
    hash = "sha256-8fcBIcZ2l6mkKe9YQe5+5fh7+vK9qxzBO2kLRUONumQ=";
  };

  disabled = pythonOlder "3.11";

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

  meta = with lib; {
    description = "NDN client library with AsyncIO support";
    homepage = "https://github.com/named-data/python-ndn";
    changelog = "https://github.com/named-data/python-ndn/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
