{
  cccl,
  cuda_cudart,
  cuda_crt,
  cudaNamePrefix,
  lib,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "${cudaNamePrefix}-tests-cudart-pkg-config";
  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cuda_cudart ];
  dontUnpack = true;

  # Cover both conventional names and an explicit, nonconventional mapping.
  passthru.tests = lib.genAttrs [ "dev-headers" "bin-headers" ] (
    name:
    let
      output = lib.removeSuffix "-headers" name;
      headersInOutput =
        package:
        package.overrideAttrs (old: {
          outputs = [
            "out"
            output
          ];
          outputInclude = output;
          passthru = old.passthru // {
            outputToPatterns = old.passthru.outputToPatterns // {
              ${output} = [ "include" ];
            };
          };
        });
    in
    finalAttrs.finalPackage.overrideAttrs {
      name = "${cudaNamePrefix}-tests-cudart-pkg-config-${name}";
      buildInputs = [
        (cuda_cudart.override {
          cuda_crt = headersInOutput cuda_crt;
          cccl = headersInOutput cccl;
        })
      ];
    }
  );

  buildPhase = ''
    runHook preBuild
    cat > consumer.cpp <<'CPP'
    #include <cuda_runtime_api.h>
    #include <cuda/std/type_traits>
    static_assert(cuda::std::is_integral_v<int>);
    int main() {
      int version;
      return cudaRuntimeGetVersion(&version);
    }
    CPP

    # Test the installed interface, not ambient propagation of CRT/CCCL.
    # Keep pkg-config's normal role-aware lookup, but pass only its flags to
    # the compiler. The wrapper still supplies its own standard toolchain.
    local role
    for role in "" _FOR_BUILD _FOR_HOST _FOR_TARGET; do
      unset "NIX_CFLAGS_COMPILE$role" "NIX_LDFLAGS$role"
    done
    local -a flags
    read -r -a flags <<< "$($PKG_CONFIG --cflags --libs cudart)"
    "$CXX" -std=c++17 consumer.cpp "''${flags[@]}" -o consumer
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp consumer "$out/bin/consumer"
    runHook postInstall
  '';
})
