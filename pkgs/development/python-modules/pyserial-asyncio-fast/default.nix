{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  wheel,

  # dependencies
  pyserial,

  # tests
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pyserial-asyncio-fast";
  version = "0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "pyserial-asyncio-fast";
    rev = version;
    hash = "sha256-B1CLk7ggI7l+DaMDlnMjl2tfh+evvaf1nxzBpmqMBZk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ pyserial ];

  pythonImportsCheck = [ "serial_asyncio_fast" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  meta = with lib; {
    description = "Fast asyncio extension package for pyserial that implements eager writes";
    homepage = "https://github.com/bdraco/pyserial-asyncio-fast";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
