{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "keyboard";
  # the commit tagged v0.13.5 on github actually has version 0.13.4,
  # and fetchPypi reports 404 error; very strange!
  version = "0.13.5-unstable-2023-01-31";

  src = fetchFromGitHub {
    owner = "boppreh";
    repo = "keyboard";
    rev = "d232de09bda50ecb5211ebcc59b85bc6da6aaa24";
    hash = "sha256-Xk419Zvx9pDgMcaWZn52WD41cFaXXzJlvmPGxaWdR0k=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  pythonImportsCheck = [ "keyboard" ];

  # Specific OS tests are being run for other OS, like
  # winmouse on Linux, which provides the following error:
  # AttributeError: module 'ctypes' has no attribute 'WinDLL'
  doCheck = false;

  meta = {
    description = "Hook and simulate keyboard events on Windows and Linux";
    homepage = "https://github.com/boppreh/keyboard";
    changelog = "https://github.com/boppreh/keyboard/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.linux;
  };
}
