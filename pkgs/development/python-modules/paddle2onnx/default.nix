{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pythonAtLeast,
  python,
  cmake,
  onnx,
  packaging,
  paddlepaddle,
  protobuf_21,
  pybind11,
  setuptools,
  setuptools-scm,
  wheel,
}:
let
  version = "2.1.0";

  # submodules compiled in, revisions from upstream .gitmodules
  onnx-src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    rev = "990217f043af7222348ca8f0301e17fa7b841781";
    hash = "sha256-mgYrY3IXUMgG/2/SjwMWAX0FneY+E8SpLDMnB9EUbF4=";
  };

  onnx-optimizer-src = fetchFromGitHub {
    owner = "onnx";
    repo = "optimizer";
    rev = "b3a4611861734e0731bbcc2bed1f080139e4988b";
    hash = "sha256-PIm039A/YccE5dRMXt1lptQ+kxxdQFtAdkZZQaiGo9c=";
  };

  # libpaddle.so exports its own bundled glog under `google::`, and those symbols
  # interpose over ours. A newer glog links fine but segfaults on import.
  glog-src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    tag = "v0.4.0";
    hash = "sha256-K3X199xY2uLDeNeScDufu1tRemF05ZwYrH25G6Oqo/U=";
  };
in
buildPythonPackage {
  pname = "paddle2onnx";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PaddlePaddle";
    repo = "Paddle2ONNX";
    tag = "v${version}";
    hash = "sha256-EZDhQUI9WgLTsZx2bUC31JfMudI3hqjshAVkfnleXHI=";
  };

  disabled = pythonOlder "3.12" || pythonAtLeast "3.14";

  # Use nixpkgs' pybind11 instead of the bundled copy.
  patches = [ ./cmake-external-deps.patch ];

  postPatch = ''
    cp -r --no-preserve=mode ${onnx-src}/. third_party/onnx
    cp -r --no-preserve=mode ${onnx-optimizer-src}/. third_party/optimizer
    cp -r --no-preserve=mode ${glog-src}/. third_party/glog

    # cmake locates libpaddle.so and paddle's headers by probing site-packages,
    # which never turns up a PYTHONPATH dependency.
    substituteInPlace CMakeLists.txt \
      --replace-fail "import site; print(';'.join(site.getsitepackages()))" \
                     "print('${paddlepaddle}/${python.sitePackages}')"

    substituteInPlace pyproject.toml \
      --replace-fail '"cmake>=3.16",' "" \
      --replace-fail '"paddlepaddle==3.0.0.dev20250426",' '"paddlepaddle",'
  '';

  build-system = [
    paddlepaddle
    setuptools
    setuptools-scm
    wheel
  ];

  # setup.py drives cmake itself.
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    protobuf_21
  ];

  buildInputs = [
    protobuf_21
    pybind11
  ];

  dependencies = [
    onnx
    packaging # imported by __init__.py, undeclared upstream
    paddlepaddle
  ];

  env = {
    # Without CMAKE_INSTALL_LIBDIR the vendored onnx fails to find libprotobuf
    # next to protoc and tries to download its own copy.
    CMAKE_ARGS = "-DCMAKE_INSTALL_LIBDIR=lib";
    SETUPTOOLS_SCM_PRETEND_VERSION = version;
  };

  pythonRelaxDeps = [ "onnx" ];

  # optional, imported lazily and skipped when missing
  pythonRemoveDeps = [ "polygraphy" ];

  pythonImportsCheck = [ "paddle2onnx" ];

  meta = {
    description = "ONNX Model Exporter for PaddlePaddle";
    homepage = "https://github.com/PaddlePaddle/Paddle2ONNX";
    changelog = "https://github.com/PaddlePaddle/Paddle2ONNX/releases/tag/v${version}";
    mainProgram = "paddle2onnx";
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
