{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "async-cache";
  version = "1.1.1";

  format = "setuptools";

  src = fetchPypi {
    pname = "async-cache";
    inherit version;
    hash = "sha256-gaqczRn7BnhKrzC9XyBD3Aoj/D6Zi5PQwsF9GvmAM5M=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

#  pytestFlagsArray = [
#    "src/zope/cachedescriptors/tests.py"
#  ];

  pythonImportsCheck = [ "cache" ];

  meta = {
    description = "A caching solution for asyncio";
    homepage = "https://github.com/iamsinghrajat/async-cache";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jloyet ];
  };
}
