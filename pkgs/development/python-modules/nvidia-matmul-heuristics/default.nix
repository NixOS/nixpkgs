{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,

  # nativeBuildInputs
  autoPatchelfHook,

  # tests
  pytestCheckHook,
}:

let
  version = "0.1.0.27";

  # One wheel per system, exposed as passthru.srcs so the update script refreshes every hash.
  srcs =
    lib.mapAttrs
      (
        _:
        { platform, hash }:
        fetchPypi {
          pname = "nvidia_matmul_heuristics";
          inherit version platform hash;
          format = "wheel";
          python = "py3";
          dist = "py3";
          abi = "none";
        }
      )
      {
        x86_64-linux = {
          platform = "manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_28_x86_64";
          hash = "sha256-QQeuVDCNkmKmsUwwmCxFxyC5xfQZa/k9rGT2c57Y+Nk=";
        };
        aarch64-linux = {
          platform = "manylinux_2_28_aarch64";
          hash = "sha256-R1zRdKrVz1tYKMyJSwf6lq169caBomMcB36/SCyS5K0=";
        };
      };
in
buildPythonPackage {
  pname = "nvidia-matmul-heuristics";
  inherit version;
  format = "wheel";
  __structuredAttrs = true;

  src =
    srcs.${stdenv.hostPlatform.system}
      or (throw "nvidia-matmul-heuristics is not supported on ${stdenv.hostPlatform.system}");

  # Fails the build if a dependency of the bundled libnvMatmulHeuristics.so.0 is missing (it currently needs only glibc).
  nativeBuildInputs = [ autoPatchelfHook ];

  pythonImportsCheck = [ "nvMatmulHeuristics" ];

  # The wheel ships no tests. The heuristics are an analytical model evaluated on the CPU, so a GPU isn't needed to
  # exercise them.
  nativeCheckInputs = [
    pytestCheckHook
  ];
  enabledTestPaths = [ ./test_nvmatmulheuristics.py ];

  passthru = {
    inherit srcs;
    updateScript = nix-update-script {
      extraArgs = [
        "--url=mirror://pypi/n/nvidia-matmul-heuristics/"
        # The wheels' fetchers carry no position, so name the file their hashes live in.
        "--override-filename=pkgs/development/python-modules/nvidia-matmul-heuristics/default.nix"
        "--no-src"
      ]
      ++ lib.concatMap (name: [
        "--subpackage"
        "srcs.${name}"
      ]) (lib.attrNames srcs);
    };
  };

  meta = {
    description = "Heuristics for GEMM kernel meta-parameter selection and auto-tuning";
    homepage = "https://docs.nvidia.com/cuda/nvidia-matmul-heuristics/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.nvidiaMath_sdk_sla;
    maintainers = with lib.maintainers; [
      GaetanLepage
      connorbaker
    ];
    teams = [ lib.teams.cuda ];
    platforms = lib.attrNames srcs;
  };
}
