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
  version = "0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "pyserial-asyncio-fast";
    rev = version;
    hash = "sha256-37dbJq+9Ex+/uiRR2esgOP15CjySA0MLvxnjiPDTF08=";
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
