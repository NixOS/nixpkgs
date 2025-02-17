{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "busypie";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rockem";
    repo = "busypie";
    tag = "v${version}";
    hash = "sha256-dw0Sc/a27/EYY7LVMQqDkYuxrUFYK+N6XLk6A7A/eS8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "busypie" ];

  meta = with lib; {
    description = "Expressive busy wait for Python";
    homepage = "https://github.com/rockem/busypie";
    changelog = "https://github.com/rockem/busypie/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
