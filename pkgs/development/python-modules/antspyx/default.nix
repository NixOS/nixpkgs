{
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  cmake,
  nanobind,
  ninja,
  packaging,
  scikit-build-core,
  # buildInputs
  itk,
  ants,
  vtk,
  # dependencies
  matplotlib,
  numpy,
  pandas,
  pillow,
  pyyaml,
  requests,
  scikit-learn,
  scipy,
  statsmodels,
  webcolors,
}:

buildPythonPackage (finalAttrs: {
  pname = "antspyx";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ANTsX";
    repo = "ANTsPy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DH/yPd644aExLPTR6QttwkGsEZuWstGfYdEK2ablwAg=";
  };

  # tries to clone and build its own ITK and ANTs, so unvendor
  # note (Oct. 13, 2026): the pinned ANTs version in configure_ANTS.sh is
  # currently slightly ahead of `ants.src`; specifically, unvendoring removes
  # new antspy support for transforming vector-valued images (resolved by next ants release).
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail '"nanobind >=1.3.2,<2.6"' '"nanobind"'

    substituteInPlace CMakeLists.txt \
      --replace-fail 'execute_process(COMMAND bash ''${PROJECT_SOURCE_DIR}/scripts/configure_ITK.sh)' "" \
      --replace-fail 'execute_process(COMMAND bash ''${PROJECT_SOURCE_DIR}/scripts/configure_ANTs.sh)' "" \
      --replace-fail 'set(ITK_DIR "./itkbuild")' ""

    mkdir src/antscore
    for d in Examples Examples/include ImageRegistration ImageSegmentation Tensor Temporary Utilities; do
      cp -r --no-preserve=mode ${ants.src}/$d/* src/antscore/
    done
    cp src/ANTsVersionConfig.h src/antscore/
  '';

  build-system = [
    cmake
    nanobind
    ninja
    scikit-build-core
    packaging
  ];

  buildInputs = [
    itk
    # note VTK is not actually used by this package, but is still required at link time for some reason
    # (likely due to the default ITK in Nixpkgs enabling ITKVTKGlue)
    vtk
  ];

  dependencies = [
    matplotlib
    numpy
    pandas
    pillow
    pyyaml
    requests
    statsmodels
    scikit-learn
    scipy
    webcolors
  ];

  pythonRelaxDeps = [
    "numpy"
    "scipy"
  ];

  dontUseCmakeConfigure = true;

  cmakeFlags = [ "-Dnanobind_DIR=${nanobind}/${python.sitePackages}/nanobind/cmake" ];

  pythonImportsCheck = [
    "ants"
  ];

  doCheck = false; # most tests try to download data

  meta = {
    description = "Fast medical imaging analysis library in Python with algorithms for registration, segmentation, and more";
    homepage = "https://antspyx.readthedocs.io";
    changelog = "https://github.com/ANTsX/ANTsPy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
