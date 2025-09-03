{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cython,
  meson-python,
  ninja,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "cysignals";
  version = "1.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "cysignals";
    tag = version;
    hash = "sha256-VwjAgJTrK703Eg+H9c8lJt2+5DGSSKv49YeWl7SPDck=";
  };

  build-system = [
    cython
    meson-python
    ninja
  ];

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  # explicit check:
  # build/src/cysignals/implementation.c:27:2: error: #error "cysignals must be compiled without _FORTIFY_SOURCE"
  hardeningDisable = [ "fortify" ];

  # known failure: https://github.com/sagemath/cysignals/blob/582dbf6a7b0f9ade0abe7a7b8720b7fb32435c3c/testgdb.py#L5
  doCheck = false;
  checkTarget = "check-install";

  preCheck = ''
    # Make sure cysignals-CSI is in PATH
    export PATH="$out/bin:$PATH"
  '';

  passthru.tests = {
    inherit sage;
  };

  meta = with lib; {
    description = "Interrupt and signal handling for Cython";
    mainProgram = "cysignals-CSI";
    homepage = "https://github.com/sagemath/cysignals/";
    teams = [ teams.sage ];
    license = licenses.lgpl3Plus;
  };
}
