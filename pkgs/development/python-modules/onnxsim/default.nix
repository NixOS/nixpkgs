{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  # build dependencies
  setuptools,
  cmake

  # TODO: add test dependencies
}:
buildPythonPackage rec {
  pname = "onnxsim";
  version = "0.4.36";
  pyproject = true;

  # upstream uses ssh submodules https://github.com/NixOS/nixpkgs/issues/195117
  src = (
    fetchFromGitHub {
      owner = "daquexian";
      repo = "onnx-simplifier";
      rev = "v${version}";
      sha256 = "sha256-T4j11tOBk4iUVxLLcCgwAZcJApEcyiZJ3tGA11TPrB4=";
      fetchSubmodules = true;
    }
  ).overrideAttrs {
      GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
      GIT_CONFIG_VALUE_0 = "git@github.com:";
      GIT_CONFIG_COUNT = 1;
  };

  build-system = [
    setuptools
    cmake
  ];

  cmakeFlags = [
    "-DONNX_USE_PROTOBUF_SHARED_LIBS=OFF"
    "-DProtobuf_USE_STATIC_LIBS=ON"
  ];

  env = {
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
    ONNXSIM_PKG_NAME="onnxsim";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "onnxsim" ];

  # TODO: this package also exports a onnxsim command, test it
  meta = {
    description = "Simplify and optimize ONNX models";
    homepage = "https://github.com/daquexian/onnx-simplifier";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ osbm ];
  };
}

