{
  lib,
  cmake,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  python,
  wheel,
}:

buildPythonPackage rec {
  pname = "cmake-build-extension";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "diegoferigo";
    repo = "cmake-build-extension";
    rev = "v${version}";
    hash = "sha256-taAwxa7Sv+xc8xJRnNM6V7WPcL+TWZOkngwuqjAslzc=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    python.pkgs.cmake
    python.pkgs.ninja
    python.pkgs.gitpython
  ];

  # don't run cmake's configure phase
  configurePhase = ''
    runHook preConfigure
    runHook postConfigure
  '';

  pythonImportsCheck = [ "cmake_build_extension" ];
  doPythonRuntimeDepsCheck = false;

  meta = {
    description = "Setuptools extension to build and package CMake projects";
    homepage = "https://github.com/diegoferigo/cmake-build-extension";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
