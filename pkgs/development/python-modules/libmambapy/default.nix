{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cmake,
  ninja,
  libmamba,
  pybind11,
  setuptools,
  wheel,
}:
buildPythonPackage rec {
  pname = "libmambapy";
  version = "1.5.7";
  pyproject = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [
    libmamba
    pybind11
  ];

  src = fetchFromGitHub {
    owner = "mamba-org";
    repo = "mamba";
    rev = "${pname}-${version}";
    hash = "sha256-HfmvLi9IBWlaGAn2Ej4Bnm4b3l19jEXwNl5IUkdVxi0=";
  };

  souceRoot = "${src.name}/libmambapy";
  cmakeFlags = [
    "-GNinja"
    (lib.cmakeBool "BUILD_LIBMAMBAPY" true)
  ];

  buildPhase = ''
    ninjaBuildPhase
    cp -r libmambapy ../libmambapy
    cd ../libmambapy
    pypaBuildPhase
  '';

  # patch needed to fix setuptools errors
  # see these for reference
  # https://stackoverflow.com/questions/72294299/multiple-top-level-packages-discovered-in-a-flat-layout
  # https://github.com/pypa/setuptools/issues/3197#issuecomment-1078770109
  patchPhase = ''
    substituteInPlace libmambapy/setup.py --replace-warn  "setuptools.setup()" "setuptools.setup(py_modules=[])"
  '';
  pythonPath = [
    setuptools
    wheel
  ];
  pythonRemoveDeps = [ "scikit-build" ];

  meta = {
    description = "The python library for the fast Cross-Platform Package Manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
