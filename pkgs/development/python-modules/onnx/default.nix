{
  buildPythonPackage,
  onnx, # pkgs.onnx

  # dependencies
  ml-dtypes,
  numpy,
  protobuf,
  typing-extensions,

  # tests
  parameterized,
  pillow,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage {
  inherit (onnx)
    pname
    src # Needed for testing.
    version
    ;

  format = "wheel";

  dontUseWheelUnpack = true;

  postUnpack = ''
    cp -rv "${onnx.dist}" "$sourceRoot/dist"
    chmod +w "$sourceRoot/dist"
  '';

  buildInputs = [
    # onnx must be included to avoid shrinking during fixupPhase removing the RUNPATH entry on
    # onnx_cpp2py_export.cpython-*.so.
    onnx
  ];

  dependencies = [
    ml-dtypes
    numpy
    protobuf
    typing-extensions
  ];

  nativeCheckInputs = [
    parameterized
    pillow
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # The executables are just utility scripts that aren't too important
  postInstall = ''
    rm -rv $out/bin
  '';

  # detecting source dir as a python package confuses pytest
  preCheck = ''
    rm onnx/__init__.py
  '';

  enabledTestPaths = [
    "onnx/test"
    "examples"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "onnx" ];

  meta = {
    # Explicitly inherit from ONNX's meta to avoid pulling in attributes added by stdenv.mkDerivation.
    inherit (onnx.meta)
      changelog
      description
      homepage
      license
      maintainers
      ;
  };
}
