{
  autoPatchelfHook,
  buildPythonPackage,
  fetchPypi,
  lib,
  librknnrt,
  numpy,
  psutil,
  python,
  ruamel-yaml,
  stdenv,
}:

let
  version = "2.3.2";

  format = "wheel";
in
buildPythonPackage {
  pname = "rknn-toolkit-lite2";
  inherit version;
  format = "wheel";
  # Pinned to the cp312 wheel, the newest tag upstream publishes (no cp313/cp314).
  disabled = lib.versions.majorMinor python.version != "3.12";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "rknn_toolkit_lite2";
    inherit version format;
    dist = "cp312";
    python = "cp312";
    abi = "cp312";
    platform = "manylinux_2_17_aarch64.manylinux2014_aarch64";
    hash = "sha256-4eTsaR/tkAwOb95efY7roX+AaqRQkrY7Nh7ndeLBtQ4=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  # The binding loads this library by its absolute /usr/lib path at runtime.
  buildInputs = [
    librknnrt
    stdenv.cc.cc.lib
  ];

  dependencies = [
    numpy
    psutil
    ruamel-yaml
  ];

  postInstall = ''
    install -Dm644 ${librknnrt.sdkLicense} "$out/share/licenses/rknn-toolkit-lite2/LICENSE"
  '';

  # The top-level package is empty; importing the API loads the compiled
  # extensions without initializing an NPU or downloading a model.
  pythonImportsCheck = [ "rknnlite.api" ];

  meta = {
    description = "Python Lite API for Rockchip NPU inference";
    homepage = "https://github.com/airockchip/rknn-toolkit2/tree/master/rknn-toolkit-lite2";
    changelog = "https://github.com/airockchip/rknn-toolkit2/releases";
    maintainers = with lib.maintainers; [ tlvince ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "aarch64-linux" ];
  };
}
