{
  config,
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
  fetchPypi,
  python,
  pythonOlder,
  pythonAtLeast,
  autoPatchelfHook,
  bash,
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
  sources = import ./sources.nix;
  version = sources.version;
  format = "wheel";
  pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
  cpuOrGpu = if cudaSupport then "gpu" else "cpu";
  hash =
    sources."${stdenv.hostPlatform.system}"."${cpuOrGpu}"."${pyShortVersion}"
      or (throw "${pname} has no sources.nix entry for '${stdenv.hostPlatform.system}.${cpuOrGpu}.${pyShortVersion}' attribute");
  platform = sources."${stdenv.hostPlatform.system}".platform;
  src =
    if cudaSupport then
      (fetchurl {
        url = "https://paddle-whl.bj.bcebos.com/stable/cu128/paddlepaddle-gpu/paddlepaddle-${version}-${pyShortVersion}-${pyShortVersion}-linux_x86_64.whl";
        inherit hash;
      })
    else
      (fetchPypi {
        inherit
          version
          format
          hash
          platform
          ;
        pname = "paddlepaddle";
        dist = pyShortVersion;
        python = pyShortVersion;
        abi = pyShortVersion;
      });
in
buildPythonPackage {
  inherit
    pname
    version
    format
    src
    ;

  disabled = pythonOlder "3.12" || pythonAtLeast "3.14";

  nativeBuildInputs = [
    addDriverRunpath
  ]
  ++ lib.optionals cudaSupport [ autoPatchelfHook ];

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

  # Segmentation fault in darwin sandbox
  pythonImportsCheck = lib.optionals stdenv.hostPlatform.isLinux [ "paddle" ];

  # no tests
  doCheck = false;

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux (
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
          patchelf --add-rpath ${libraryPath} $1
          ${lib.optionalString cudaSupport ''
            addDriverRunpath $1
          ''}
        }
        fixRunPath $out/${python.sitePackages}/paddle/base/libpaddle.so
        fixRunPath $out/${python.sitePackages}/paddle/libs/lib*.so
      ''
    )
    + ''
      substituteInPlace $out/bin/paddle \
        --replace-fail "/bin/bash" "${lib.getExe bash}" \
        --replace-fail "python -"  "${lib.getExe (python.withPackages (ps: with ps; [ distutils ]))} -"
      sed -i '/# Check python lib installed or not./,/^fi$/d' $out/bin/paddle
      sed -i 's/^INSTALLED_VERSION=.*/INSTALLED_VERSION="${version}"/' $out/bin/paddle
    '';

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
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
