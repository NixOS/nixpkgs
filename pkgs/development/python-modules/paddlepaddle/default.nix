{
  config,
  lib,
  stdenv,
  buildPythonPackage,
<<<<<<< HEAD
  fetchurl,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchPypi,
  python,
  pythonOlder,
  pythonAtLeast,
<<<<<<< HEAD
  autoPatchelfHook,
  bash,
  zlib,
  setuptools,
  cudaSupport ? config.cudaSupport or false,
  cudaPackages_12_9,
=======
  zlib,
  setuptools,
  cudaSupport ? config.cudaSupport or false,
  cudaPackages,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  addDriverRunpath,
  # runtime dependencies
  httpx,
  numpy,
  protobuf,
  pillow,
  decorator,
  astor,
  opt-einsum,
<<<<<<< HEAD
  safetensors,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  typing-extensions,
}:

let
  pname = "paddlepaddle" + lib.optionalString cudaSupport "-gpu";
<<<<<<< HEAD
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
        url = "https://paddle-whl.bj.bcebos.com/stable/cu129/paddlepaddle-gpu/paddlepaddle_gpu-${version}-${pyShortVersion}-${pyShortVersion}-linux_x86_64.whl";
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildPythonPackage {
  inherit
    pname
    version
    format
    src
    ;

<<<<<<< HEAD
  disabled = pythonOlder "3.12" || pythonAtLeast "3.14";

  nativeBuildInputs = [
    addDriverRunpath
  ]
  ++ lib.optionals cudaSupport [ autoPatchelfHook ];
=======
  disabled =
    if cudaSupport then
      (pythonOlder "3.11" || pythonAtLeast "3.13")
    else
      (pythonOlder "3.12" || pythonAtLeast "3.14");

  nativeBuildInputs = [ addDriverRunpath ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dependencies = [
    setuptools
    httpx
    numpy
    protobuf
    pillow
    decorator
    astor
    opt-einsum
<<<<<<< HEAD
    safetensors
    typing-extensions
  ];

  # Segmentation fault in darwin sandbox
  pythonImportsCheck = lib.optionals stdenv.hostPlatform.isLinux [ "paddle" ];
=======
    typing-extensions
  ];

  pythonImportsCheck = [ "paddle" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # no tests
  doCheck = false;

<<<<<<< HEAD
  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux (
      let
        libraryPath = lib.makeLibraryPath (
          [
            zlib
            (lib.getLib stdenv.cc.cc)
          ]
          ++ lib.optionals cudaSupport (
            with cudaPackages_12_9;
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

  passthru.updateScript = ./update.sh;
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
=======
      "x86_64-darwin"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
