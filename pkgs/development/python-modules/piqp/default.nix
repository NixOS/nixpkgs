{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  stdenv,
  pythonOlder,
  setuptools,
  cmake,
  ninja,
  wheel,
  matio,
  eigen,
  gtest,
  cpu_features,
  pybind11,
  python,
  numpy,
  scipy,
}:
buildPythonPackage rec {
  pname = "piqp";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PREDICT-EPFL";
    repo = "piqp";
    tag = "v${version}";
    hash = "sha256-hVUeDV2GrBAOIgaWhg+RV+8CFRIm8Kv6/wCs5bXs2aY=";
  };

  postPatch =
    let
      # E.g. 3.11.2 -> "311"
      pythonVersionMajorMinor =
        with lib.versions;
        "${major python.pythonVersion}${minor python.pythonVersion}";

      # E.g. "linux-aarch64"
      platform =
        with stdenv.hostPlatform;
        (lib.optionalString (!isDarwin) "${parsed.kernel.name}-${parsed.cpu.name}")
        + (lib.optionalString isDarwin "macosx-${darwinMinVersion}-${darwinArch}");
    in
    ''
      build="build/temp.${platform}-cpython-${pythonVersionMajorMinor}/${pname}.${pname}"
      mkdir -p $build/_deps
      ln -s ${cpu_features.src} $build/_deps/cpu_features-src
    '';

  patches = [ ./use-nix-packages.patch ];

  build-system = [
    setuptools
    cmake
    ninja
    wheel
  ];

  buildInputs = [
    matio
    eigen
    gtest
    pybind11
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "piqp" ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    scipy
  ];

  meta = with lib; {
    description = "Proximal Interior Point Quadratic Programming solver";
    homepage = "https://github.com/PREDICT-EPFL/piqp";
    license = licenses.bsd2;
    maintainers = with maintainers; [ renesat ];
  };
}
