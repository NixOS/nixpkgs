{
  lib,
  stdenv,
  fetchurl,
  graalvmPackages,
  onnxruntime,
  useMusl ? false,
  version ? "24",
}:

let
  graal =
    (graalvmPackages.buildGraalvm {
      inherit useMusl version;
      src = fetchurl (import ./hashes.nix).${version}.${stdenv.system};
      meta.platforms = builtins.attrNames (import ./hashes.nix).${version};
      meta.license = lib.licenses.unfree;
      pname = "graalvm-oracle";
    }).overrideAttrs
      (prev: {
        propagatedBuildInputs = (prev.propagatedBuildInputs or [ ]) ++ [ onnxruntime ];
        postFixup =
          (prev.postFixup or "")
          + ''
            patchelf --replace-needed libonnxruntime.so.1.18.0 libonnxruntime.so.1 $out/lib/svm/profile_inference/onnx/native/libonnxruntime4j_jni.so
          '';
      });
in
graal.overrideAttrs (prev: {
  passthru.home = graal;
})
