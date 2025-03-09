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
  version = "0.4.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ArTP4LQu7VNjI/N13gMTc1SDiNmW5l4GdLYOk8JEfKg=";
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
    changelog = "https://github.com/named-data/python-ndn/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
