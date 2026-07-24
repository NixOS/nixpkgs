{
  lib,
  makeSetupHook,
  replaceVars,
  writeText,
}:
let
  role = replaceVars ../../../../build-support/setup-hooks/role.bash {
    name = "cuda-component-hook";
    suffixSalt = "cuda";
    wrapperName = "CUDA";
  };
  script = writeText "cuda-component-hook.sh" ''
    if [[ -n ''${_cudaComponentHookSourced-} ]]; then
      nixDebugLog "CUDA component hook already sourced"
      return 0
    fi
    declare -g _cudaComponentHookSourced=1

    source ${role}
    source ${../../../../build-support/setup-hooks/arrayUtilities/isDeclaredArray/isDeclaredArray.bash}
    source ${../../../../build-support/setup-hooks/arrayUtilities/isDeclaredMap/isDeclaredMap.bash}
    source ${../../../../build-support/setup-hooks/arrayUtilities/sortArray/sortArray.bash}
    source ${../../../../build-support/setup-hooks/arrayUtilities/getSortedMapKeys/getSortedMapKeys.bash}
    declare -g _cudaComponentHookPath="@cudaComponentHook@"
    source ${./cuda-component-hook.sh}
  '';
in
makeSetupHook {
  name = "cuda-component-hook";

  substitutions = {
    cudaComponentHook = placeholder "out";
  };

  meta.license = lib.licenses.mit;
} script
