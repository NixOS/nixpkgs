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
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PREDICT-EPFL";
    repo = "piqp";
    rev = "refs/tags/v${version}";
    hash = "sha256-/lADjg4NyDdV9yeYBW2gbPydY8TfV247B/dI/ViRVlI=";
  };

  postPatch =
    let
      # E.g. 3.11.2 -> "311"
      pythonVersionMajorMinor =
        with lib.versions;
        "${major python.pythonVersion}${minor python.pythonVersion}";

      # E.g. "linux-aarch64"
      platform = with stdenv.hostPlatform.parsed; "${kernel.name}-${cpu.name}";
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
    description = "A Proximal Interior Point Quadratic Programming solver";
    homepage = "https://github.com/PREDICT-EPFL/piqp";
    license = licenses.bsd2;
    maintainers = with maintainers; [ renesat ];
  };
}
