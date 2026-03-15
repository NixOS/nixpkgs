{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mypy,
  numpy,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "comtypes";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "comtypes";
    rev = "${finalAttrs.version}";
    hash = "sha256-1d5JIN+ScWL0VWQBkZvpXN3m7rYWLeznlg4W7YUhJjE=";
  };

  doCheck = false;
  pyproject = true;

  build-system = [
    wheel
    setuptools
  ];

  dependencies = [
    numpy
    mypy
  ];

  meta = {
    changelog = "https://github.com/enthought/comtypes/releases/tag/${finalAttrs.version}";
    description = "A pure Python, lightweight COM client and server framework, based on the ctypes Python FFI package.";
    homepage = "https://github.com/enthought/comtypes/tree/${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      S0AndS0
    ];
  };
})
