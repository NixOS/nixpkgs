{
  config,
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
  pythonAtLeast,
  zlib,
  setuptools,
  cudaSupport ? config.cudaSupport or false,
  cudaPackages,
  addDriverRunpath,
  # runtime dependencies
  httpx,
  numpy,
  protobuf,
  pillow,
  decorator,
  astor,
  opt-einsum,
  typing-extensions,
}:

let
  pname = "paddlepaddle" + lib.optionalString cudaSupport "-gpu";
  version = if cudaSupport then "2.6.2" else "3.0.0";
  format = "wheel";
  pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
  cpuOrGpu = if cudaSupport then "gpu" else "cpu";
  allHashAndPlatform = import ./binary-hashes.nix;
  hash =
    allHashAndPlatform."${stdenv.hostPlatform.system}"."${cpuOrGpu}"."${pyShortVersion}"
      or (throw "${pname} has no binary-hashes.nix entry for '${stdenv.hostPlatform.system}.${cpuOrGpu}.${pyShortVersion}' attribute");
  platform = allHashAndPlatform."${stdenv.hostPlatform.system}".platform;
  src = fetchPypi {
    inherit
      version
      format
      hash
      platform
      ;
    pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
  };
in
buildPythonPackage {
  inherit
    pname
    version
    format
    src
    ;

  disabled =
    if cudaSupport then
      (pythonOlder "3.11" || pythonAtLeast "3.13")
    else
      (pythonOlder "3.12" || pythonAtLeast "3.14");

  nativeBuildInputs = [ addDriverRunpath ];

  dependencies = [
    setuptools
    httpx
    numpy
    protobuf
    pillow
    decorator
    astor
    opt-einsum
    typing-extensions
  ];

  pythonImportsCheck = [ "paddle" ];

  # no tests
  doCheck = false;

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux (
    let
      libraryPath = lib.makeLibraryPath (
        [
          zlib
          (lib.getLib stdenv.cc.cc)
        ]
        ++ lib.optionals cudaSupport (
          with cudaPackages;
          [
            cudatoolkit.lib
            cudatoolkit.out
            cudnn
          ]
        )
      );
    in
    ''
      function fixRunPath {
        p=$(patchelf --print-rpath $1)
        patchelf --set-rpath "$p:${libraryPath}" $1
        ${lib.optionalString cudaSupport ''
          addDriverRunpath $1
        ''}
      }
      fixRunPath $out/${python.sitePackages}/paddle/base/libpaddle.so
      fixRunPath $out/${python.sitePackages}/paddle/libs/lib*.so
    ''
  );

  meta = {
    description = "Machine Learning Framework from Industrial Practice";
    homepage = "https://github.com/PaddlePaddle/Paddle";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = [
      "x86_64-linux"
    ]
    ++ lib.optionals (!cudaSupport) [
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
