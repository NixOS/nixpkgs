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
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "memory_allocator";
    hash = "sha256-jBoEMsJom1K/P1y4nz2do8+l/fTNUNGMEjh0CGGtuLw=";
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
