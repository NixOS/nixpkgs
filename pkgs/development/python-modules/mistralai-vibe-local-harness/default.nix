{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchPypi,

  # nativeBuildInputs
  autoPatchelfHook,

  # dependencies
  anyio,
  certifi,
  httpx,
  mcp,
  mistralai,
  opentelemetry-api,
  pydantic,
  rfc8785,
  truststore,
}:

let
  platforms = {
    x86_64-linux = {
      name = "manylinux_2_28_x86_64";
      hashes = {
        cp312 = "sha256-YB3esbdTEGGBFtP1xjBf9yDU9DF7jARwyOK8VSu/HEU=";
      };
    };
    aarch64-linux = {
      name = "manylinux_2_28_aarch64";
      hashes = {
        cp312 = "sha256-C3Ndi70LgbXoYa6NqhsZSmRK/tPoguvEgD7QrbSFKcw=";
      };
    };
    aarch64-darwin = {
      name = "macosx_11_0_arm64";
      hashes = {
        cp312 = "sha256-+XiH5c3zO4++nfoBjeDsyzph1HNYwHX4MsWgI48vJ/I=";
      };
    };
  };
  currentPlatform =
    platforms.${stdenv.hostPlatform.system}
      or (throw "mistralai-vibe-local-harness is not supported on ${stdenv.hostPlatform.system}");

  dist = "cp${lib.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
in
buildPythonPackage (finalAttrs: {
  pname = "mistralai-vibe-local-harness";
  version = "0.5.1";
  format = "wheel";
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "mistralai_vibe_local_harness";
    inherit (finalAttrs) version;
    format = "wheel";
    inherit dist;
    python = dist;
    abi = "abi3";
    platform = currentPlatform.name;
    hash =
      currentPlatform.hashes.${dist}
        or (throw "python${python.pythonVersion}Packages.mistralai-vibe-local-harness is not supported");
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  pythonRelaxDeps = [
    "certifi"
  ];
  dependencies = [
    anyio
    certifi
    httpx
    mcp
    mistralai
    opentelemetry-api
    pydantic
    rfc8785
    truststore
  ];

  pythonImportsCheck = [ "mistralai_vibe_local_harness" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Local unified harness runtime and native bindings for Vibe";
    homepage = "https://pypi.org/project/mistralai-vibe-local-harness/";
    license = lib.licenses.asl20;
    platforms = lib.attrNames platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
