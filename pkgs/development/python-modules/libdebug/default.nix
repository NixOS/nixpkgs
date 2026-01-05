{
  lib,
  buildPythonPackage,
  cmake,
  elfutils,
  fetchFromGitHub,
  libdwarf,
  libiberty,
  nanobind,
  ninja,
  pkg-config,
  prompt-toolkit,
  psutil,
  pyelftools,
  requests,
  scikit-build-core,
  typing-extensions,
  writableTmpDirAsHomeHook,
  zlib,
  zstd,
}:

buildPythonPackage rec {
  pname = "libdebug";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "libdebug";
    repo = "libdebug";
    tag = version;

    hash = "sha256-J0ETzqAGufsZyW+XDhJCKwX1rrmDBwlAicvBb1AAiIQ=";
  };

  dontUseCmakeConfigure = true;
  pyproject = true;
  build-system = [ scikit-build-core ];

  buildInputs = [
    libdwarf
    elfutils
    zstd
    libiberty
    zlib
  ];

  dependencies = [
    psutil
    pyelftools
    requests
    prompt-toolkit
    nanobind
    typing-extensions
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  pythonImportsCheck = [ "libdebug" ];
  meta = {
    homepage = "https://github.com/libdebug/libdebug";
    description = "Programmatic debugging of userland Linux binaries";
    maintainers = with lib.maintainers; [ mrsmoer ];
    license = lib.licenses.mit;
  };
}
