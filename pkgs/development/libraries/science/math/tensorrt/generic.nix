{ lib
, stdenv
, requireFile
, autoPatchelfHook
, autoAddOpenGLRunpathHook
, cudaVersion
, cudatoolkit
, cudnn
}:

{ fullVersion
, fileVersionCudnn
, tarball
, sha256
, supportedCudaVersions ? [ ]
}:

assert lib.assertMsg (lib.strings.versionAtLeast cudnn.version fileVersionCudnn)
  "This version of TensorRT requires at least cuDNN ${fileVersionCudnn} (current version is ${cudnn.version})";

stdenv.mkDerivation rec {
  pname = "cudatoolkit-${cudatoolkit.majorVersion}-tensorrt";
  version = fullVersion;
  src = requireFile rec {
    name = tarball;
    inherit sha256;
    message = ''
      To use the TensorRT derivation, you must join the NVIDIA Developer Program and
      download the ${version} Linux x86_64 TAR package for CUDA ${cudaVersion} from
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
    # Check that the cudatoolkit version satisfies our min/max constraints (both
    # inclusive). We mark the package as broken if it fails to satisfies the
    # official version constraints (as recorded in default.nix). In some cases
    # you _may_ be able to smudge version constraints, just know that you're
    # embarking into unknown and unsupported territory when doing so.
    broken = !(elem cudaVersion supportedCudaVersions);
    description = "TensorRT: a high-performance deep learning interface";
    homepage = "https://developer.nvidia.com/tensorrt";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aidalgol ];
  };
}
