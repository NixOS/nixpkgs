{
  addDriverRunpath,
  backendStdenv,
  cuda_cudart,
  cuda_nvcc,
  flags,
  lib,
}:
# Checks that programs linked through the nvlink wrapper run; see README.md.
backendStdenv.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;

  name = "${cuda_nvcc.name}-gpu-check";

  # NOTE: -dlto conflicts with -gencode, so the link-time optimized program is built for the first architecture only.
  variants = [
    flags.gencodeString
    "-arch=${lib.head flags.realArches} -dlto"
  ];

  nativeBuildInputs = [ cuda_nvcc ];

  buildInputs = [ cuda_cudart ];

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    for i in "''${!variants[@]}"; do
      # shellcheck disable=SC2086
      nvcc -rdc=true ''${variants[$i]} ${./gpu-check.cu} -L${lib.getOutput "static" cuda_cudart}/lib -o "program-$i"
    done
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    export LD_LIBRARY_PATH="$(readlink -mnv "${addDriverRunpath.driverLink}/lib")"
    for i in "''${!variants[@]}"; do
      nixLog "running the program built with ''${variants[$i]}"
      status=0
      output="$("./program-$i")" || status=$?
      if ((status != 0)) || [[ $output != 42 ]]; then
        nixErrorLog "expected the program to print 42, but it printed \"$output\" and exited with $status"
        exit 1
      fi
    done
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    touch "$out"
    runHook postInstall
  '';

  requiredSystemFeatures = [ "cuda" ];

  meta = {
    inherit (cuda_nvcc.meta) badPlatforms platforms teams;
  };
}
