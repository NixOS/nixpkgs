{
  lib,
  buildPythonPackage,
  fetchzip,
  setuptools,
  requests,
  responses,
  authheaders,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "liblore";
  version = "0.10.1";
  pyproject = true;

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/liblore/liblore.git/snapshot/${version}.tar.gz";
    hash = "sha256-rJ66JfPhGQYjqUOTXOacCFUlZqBAhT4S7by52zc/5Oc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    authheaders
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
    typing-extensions
  ];

  meta = {
    description = "Python library for fetching and parsing threads from lore.kernel.org and other public-inbox servers";
    homepage = "https://git.kernel.org/pub/scm/utils/liblore/liblore.git";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ feyorsh ];
  };
}
