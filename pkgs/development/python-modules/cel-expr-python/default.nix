{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchPypi,
  autoPatchelfHook,
}:

let
  abi = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
  platform =
    {
      "x86_64-linux" = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
      "aarch64-linux" = "manylinux_2_26_aarch64.manylinux_2_28_aarch64";
    }
    .${stdenv.hostPlatform.system};
  hashes = {
    "x86_64-linux" = {
      "cp313" = "sha256-vD79M21LwFPNwfhTed0/lm41lrYnrtmO2Rx3XCbxzMI=";
      "cp314" = "sha256-kUCRHY+52MqADs95c4ujVS9S3UmrtwYVvU3QLAAHg20=";
    };
    "aarch64-linux" = {
      "cp313" = "sha256-2JXz/r2gQ6/Zcohs6eYfgfFNm8hiuYxIjCI1aK6Idns=";
      "cp314" = "sha256-4ERVSD3mL5oA2dRocWqaN1RGHQbDDhhFsc4KbPjuMFU=";
    };
  };
in
buildPythonPackage (finalAttrs: {
  pname = "cel-expr-python";
  version = "0.1.4";

  # I tried building this from source with Bazel, but failed
  format = "wheel";

  src = fetchPypi {
    pname = "cel_expr_python";
    inherit (finalAttrs) version;
    format = "wheel";
    inherit abi platform;
    dist = abi;
    python = abi;
    hash = hashes.${stdenv.hostPlatform.system}.${abi};
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  pythonImportsCheck = [ "cel_expr_python" ];

  meta = {
    description = "The CEL Python runtime";
    homepage = "https://github.com/cel-expr/cel-python";
    changelog = "https://github.com/cel-expr/cel-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames hashes;
  };
})
