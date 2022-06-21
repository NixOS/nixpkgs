{ lib
, stdenv
, requireFile
, autoPatchelfHook
, autoAddOpenGLRunpathHook
, cudaVersion
, cudatoolkit
, cudnn
}:

assert lib.assertMsg (lib.strings.versionAtLeast cudaVersion "11.0")
  "This version of TensorRT requires at least CUDA 11.0 (current version is ${cudaVersion})";
assert lib.assertMsg (lib.strings.versionAtLeast cudnn.version "8.3")
  "This version of TensorRT requires at least cuDNN 8.3 (current version is ${cudnn.version})";

stdenv.mkDerivation rec {
  pname = "cudatoolkit-${cudatoolkit.majorVersion}-tensorrt";
  version = "8.4.0.6";
  src = requireFile rec {
    name = "TensorRT-${version}.Linux.x86_64-gnu.cuda-11.6.cudnn8.3.tar.gz";
    sha256 = "sha256-DNgHHXF/G4cK2nnOWImrPXAkOcNW6Wy+8j0LRpAH/LQ=";
    message = ''
      To use the TensorRT derivation, you must join the NVIDIA Developer Program
      and download the ${version} Linux x86_64 TAR package from
      ${meta.homepage}.

      Once you have downloaded the file, add it to the store with the following
      command, and try building this derivation again.

      $ nix-store --add-fixed sha256 ${name}
    '';
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    autoPatchelfHook
    autoAddOpenGLRunpathHook
  ];

  # Used by autoPatchelfHook
  buildInputs = [
    cudatoolkit.cc.cc.lib # libstdc++
    cudatoolkit
    cudnn
  ];

  sourceRoot = "TensorRT-${version}";

  installPhase = ''
    install --directory "$dev" "$out"
    mv include "$dev"
    mv targets/x86_64-linux-gnu/lib "$out"
    install -D --target-directory="$out/bin" targets/x86_64-linux-gnu/bin/trtexec
  '';

  # Tell autoPatchelf about runtime dependencies.
  # (postFixup phase is run before autoPatchelfHook.)
  postFixup =
    let
      mostOfVersion = builtins.concatStringsSep "."
        (lib.take 3 (lib.versions.splitVersion version));
    in
    ''
      echo 'Patching RPATH of libnvinfer libs'
      patchelf --debug --add-needed libnvinfer.so \
        "$out/lib/libnvinfer.so.${mostOfVersion}" \
        "$out/lib/libnvinfer_plugin.so.${mostOfVersion}" \
        "$out/lib/libnvinfer_builder_resource.so.${mostOfVersion}"
    '';

  meta = with lib; {
    description = "TensorRT: a high-performance deep learning interface";
    homepage = "https://developer.nvidia.com/tensorrt";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
  };
}
