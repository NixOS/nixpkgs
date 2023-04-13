{ lib
, fetchpatch
, buildPythonPackage
, pythonOlder
, fetchPypi
, flake8
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-flake8";
  version = "1.1.1";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba4f243de3cb4c2486ed9e70752c80dd4b636f7ccb27d4eba763c35ed0cd316e";
  };

  patches = [
    # https://github.com/tholo/pytest-flake8/issues/87
    # https://github.com/tholo/pytest-flake8/pull/88
    (fetchpatch {
      url = "https://github.com/tholo/pytest-flake8/commit/976e6180201f7808a3007c8c5903a1637b18c0c8.patch";
      hash = "sha256-Hbcpz4fTXtXRnIWuKuDhOVpGx9H1sdQRKqxadk2s+uE=";
    })
  ];

  propagatedBuildInputs = [
    flake8
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "py.test plugin for efficiently checking PEP8 compliance";
    homepage = "https://github.com/tholo/pytest-flake8";
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
    broken = lib.versionAtLeast flake8.version "6.0.0";
  };
}
