{
  cmake,
  cudaPackages,
  fetchFromGitHub,
  lib,
  ninja,
  python3Packages ? { },
  pythonSupport ? false,
  stdenv,
  symlinkJoin,
  which,
}:
let
  inherit (lib) lists strings;
  inherit (cudaPackages) backendStdenv cudaFlags;

  cuda-common-redist = with cudaPackages; [
    cuda_cudart.dev # cuda_runtime.h
    cuda_cudart.lib
    cuda_cccl.dev # <nv/target>
    libcublas.dev # cublas_v2.h
    libcublas.lib
    libcusolver.dev # cusolverDn.h
    libcusolver.lib
    libcusparse.dev # cusparse.h
    libcusparse.lib
  ];

  cuda-native-redist = symlinkJoin {
    name = "cuda-redist";
    paths = with cudaPackages; [ cuda_nvcc ] ++ cuda-common-redist;
  };

  cuda-redist = symlinkJoin {
    name = "cuda-redist";
    paths = cuda-common-redist;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tiny-cuda-nn";
  version = "1.6";
  strictDeps = true;

  format = strings.optionalString pythonSupport "setuptools";

  src = fetchFromGitHub {
    owner = "NVlabs";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-qW6Fk2GB71fvZSsfu+mykabSxEKvaikZ/pQQZUycOy0=";
  };

  nativeBuildInputs =
    [
      cmake
      cuda-native-redist
      ninja
      which
    ]
    ++ lists.optionals pythonSupport (
      with python3Packages;
      [
        pip
        setuptools
        wheel
      ]
    );

  buildInputs =
    [
      cuda-redist
    ]
    ++ lib.optionals pythonSupport (
      with python3Packages;
      [
        pybind11
        python
      ]
    );

  propagatedBuildInputs = lib.optionals pythonSupport (
    with python3Packages;
    [
      torch
    ]
  );

  # NOTE: We cannot use pythonImportsCheck for this module because it uses torch to immediately
  #   initailize CUDA and GPU access is not allowed in the nix build environment.
  # NOTE: There are no tests for the C++ library or the python bindings, so we just skip the check
  #   phase -- we're not missing anything.
  doCheck = false;

  preConfigure = ''
    export TCNN_CUDA_ARCHITECTURES="${strings.concatStringsSep ";" (lists.map cudaFlags.dropDot cudaFlags.cudaCapabilities)}"
    export CUDA_HOME="${cuda-native-redist}"
    export LIBRARY_PATH="${cuda-native-redist}/lib/stubs:$LIBRARY_PATH"
    export CC="${backendStdenv.cc}/bin/cc"
    export CXX="${backendStdenv.cc}/bin/c++"
  '';

  # When building the python bindings, we cannot re-use the artifacts from the C++ build so we
  # skip the CMake confurePhase and the buildPhase.
  dontUseCmakeConfigure = pythonSupport;

  # The configurePhase usually puts you in the build directory, so for the python bindings we
  # need to change directories to the source directory.
  configurePhase = strings.optionalString pythonSupport ''
    runHook preConfigure
    mkdir -p "$NIX_BUILD_TOP/build"
    cd "$NIX_BUILD_TOP/build"
    runHook postConfigure
  '';

  buildPhase = strings.optionalString pythonSupport ''
    runHook preBuild
    python -m pip wheel \
      --no-build-isolation \
      --no-clean \
      --no-deps \
      --no-index \
      --verbose \
      --wheel-dir "$NIX_BUILD_TOP/build" \
      "$NIX_BUILD_TOP/source/bindings/torch"
    runHook postBuild
  '';

  installPhase =
    ''
      runHook preInstall
      mkdir -p "$out/lib"
    ''
    # Installing the C++ library just requires copying the static library to the output directory
    + strings.optionalString (!pythonSupport) ''
      cp libtiny-cuda-nn.a "$out/lib/"
    ''
    # Installing the python bindings requires building the wheel and installing it
    + strings.optionalString pythonSupport ''
      python -m pip install \
        --no-build-isolation \
        --no-cache-dir \
        --no-deps \
        --no-index \
        --no-warn-script-location \
        --prefix="$out" \
        --verbose \
        ./*.whl
    ''
    + ''
      runHook postInstall
    '';

  passthru = {
    inherit cudaPackages;
  };

  meta = with lib; {
    description = "Lightning fast C++/CUDA neural network framework";
    homepage = "https://github.com/NVlabs/tiny-cuda-nn";
    license = licenses.bsd3;
    maintainers = with maintainers; [ connorbaker ];
    platforms = platforms.linux;
  };
})
