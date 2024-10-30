{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  libheif,
  piexif,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyheif";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "carsales";
    repo = "pyheif";
    rev = "refs/tags/release-${version}";
    hash = "sha256-7De8ekDceSkUcOgK7ppKad5W5qE0yxdS4kbgYVjxTGg=";
  };

  build-system = [ setuptools ];

  buildInputs = [ libheif ];

  dependencies = [ cffi ];

  pythonImportsCheck = [ "pyheif" ];

  nativeCheckInputs = [
    piexif
    pillow
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/carsales/pyheif";
    description = "Python interface to libheif library";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
