{
  lib,
  bleak,
  click,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyzerproc";
  version = "0.4.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "pyzerproc";
    tag = version;
    hash = "sha256-vS0sk/KjDhWispZvCuGlmVLLfeFymHqxwNzNqNRhg6k=";
  };

  patches = [ ./bleak-compat.patch ];

  build-system = [ setuptools ];

  dependencies = [
    bleak
    click
  ];

  doCheck = false; # tries to access dbus, which leads to FileNotFoundError

  pythonImportsCheck = [ "pyzerproc" ];

  meta = with lib; {
    description = "Python library to control Zerproc Bluetooth LED smart string lights";
    mainProgram = "pyzerproc";
    homepage = "https://github.com/emlove/pyzerproc";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
