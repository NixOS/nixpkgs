{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, isPy3k
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "backports.functools_lru_cache";
  version = "1.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5ed2169378b67d3c545e5600d363a923b09c456dab1593914935a68ad478271";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Test fail on Python 2
  doCheck = isPy3k;

  pythonNamespaces = [ "backports" ];

  meta = {
    description = "Backport of functools.lru_cache";
    homepage = "https://github.com/jaraco/backports.functools_lru_cache";
    license = lib.licenses.mit;
  };
}
