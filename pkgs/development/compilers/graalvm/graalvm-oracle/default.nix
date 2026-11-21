{
  lib,
  stdenv,
  fetchurl,
  graalvmPackages,
  useMusl ? false,
  version ? "25",
}:

# ONNX backend needs libonnxruntime.so.1, which is only shipped unversioned.
(graalvmPackages.buildGraalvm {
  inherit useMusl version;
  src = fetchurl (import ./hashes.nix).${version}.${stdenv.system};
  meta.platforms = builtins.attrNames (import ./hashes.nix).${version};
  meta.license = lib.licenses.unfree;
  pname = "graalvm-oracle";
}).overrideAttrs
  (prev: {
    postInstall =
      prev.postInstall
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        onnxNativeDir="$out/lib/svm/profile_inference/onnx/native"
        if [ -e "$onnxNativeDir/libonnxruntime.so" ]; then
          ln -s libonnxruntime.so "$onnxNativeDir/libonnxruntime.so.1"
        fi
      '';
  })
