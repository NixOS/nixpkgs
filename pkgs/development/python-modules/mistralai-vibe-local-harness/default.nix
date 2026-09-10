{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchPypi,
}:
let
  platform =
    {
      x86_64-linux = "manylinux_2_28_x86_64";
      aarch64-linux = "manylinux_2_28_aarch64";
      aarch64-darwin = "macosx_11_0_arm64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "nvidia-cutlass-dsl-libs-base is not supported on ${stdenv.hostPlatform.system}");

  pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";

  hashes = {
    x86_64-linux = {
      cp312 = "";
    };
    aarch64-linux = {
      cp312 = "";
    };
    aarch64-darwin = {
      cp312 = "";
    };
  };
in
buildPythonPackage (finalAttrs: {
  pname = "mistralai-vibe-local-harness";
  version = "0.4.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "mistralai_vibe_local_harness";
    inherit (finalAttrs) version;
    format = "wheel";
    inherit platform;
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
    hash =
      hashes.${stdenv.hostPlatform.system}.${pyShortVersion}
        or (throw "No hash specified for '${stdenv.hostPlatform.system}.${pyShortVersion}'");
  };
})
