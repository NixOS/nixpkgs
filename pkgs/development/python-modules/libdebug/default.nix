{
  lib,
  scikit-build-core,
  cmake,
  ninja,
  pkg-config,
  zstd,
  zlib,
  elfutils,
  libdwarf,
  libiberty,
  fetchFromGitHub,
  psutil,
  pyelftools,
  requests,
  prompt-toolkit,
  nanobind,
  typing-extensions,
  python,
}:

python.pkgs.buildPythonPackage rec {
  pname = "libdebug";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "libdebug";
    repo = pname;
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

  propagatedBuildInputs = [
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

  pythonImportsCheckPhase = ''
    echo "Not Executing pythonImportsCheckPhase, because importing creates a history in .cache";
  '';

  pythonImportsCheck = [ "libdebug" ];
  meta = with lib; {
    homepage = "https://github.com/libdebug/libdebug";
    description = "libdebug - A Python library to debug binary executables, your own way. ";
    maintainers = [ maintainers.mrsmoer ];
    license = licenses.mit;
  };
}
