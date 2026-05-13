{
  lib,
  fetchPypi,
  buildPythonPackage,
  pkg-config,
  meson-python,
  cython,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "memory-allocator";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "memory_allocator";
    hash = "sha256-Z108kQGduYyXRB3nPVxkiCHlroE/P1TNCYY9R0tI/iY=";
  };

  nativeBuildInputs = [ pkg-config ];

  build-system = [
    meson-python
    cython
  ];

  propagatedBuildInputs = [ cython ];

  pythonImportsCheck = [ "memory_allocator" ];

  passthru.tests = {
    inherit sage;
  };

  meta = {
    description = "Extension class to allocate memory easily with cython";
    homepage = "https://github.com/sagemath/memory_allocator/";
    teams = [ lib.teams.sage ];
    license = lib.licenses.lgpl3Plus;
  };
}
