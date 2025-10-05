{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  cmake,
  nanobind,
  ninja,
  scikit-build-core,
  setuptools,
  numpy,
  pytestCheckHook,
  scipy,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "ducc0";
  version = "0.38.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "mtr";
    repo = "ducc";
    tag = "ducc0_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-Be7lw9i1uEOY3w/Efnn7sZ4Xg5DenQuih6uReCmOI1I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail '"pybind11>=2.13.6", ' ""
  '';

  DUCC0_USE_NANOBIND = "";
  DUCC0_OPTIMIZATION = "portable";

  build-system = [
    cmake
    nanobind
    ninja
    scikit-build-core
    setuptools
  ];
  dontUseCmakeConfigure = true;
  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
    pytest-xdist
  ];
  enabledTestPaths = [ "python/test" ];
  pythonImportsCheck = [ "ducc0" ];

  postInstall = ''
    mkdir -p $out/include
    cp -r ${src}/src/ducc0 $out/include
  '';

  meta = {
    homepage = "https://gitlab.mpcdf.mpg.de/mtr/ducc";
    description = "Efficient algorithms for Fast Fourier transforms and more";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ parras ];
  };
}
