{
  callPackage,
  callPackages,
  cudaNamePrefix,
  lib,
  runCommand,
}:
let
  consumer =
    {
      cuda_nvcc,
      cuda_cudart,
      stdenv,
      label ? "default",
    }:
    stdenv.mkDerivation {
      name = "cuda-scope-consumer-${label}";
      nativeBuildInputs = [ cuda_nvcc ];
      buildInputs = [ cuda_cudart ];
      buildCommand = "touch $out";
    };
  individual = callPackage consumer { };
  grouped = callPackages (lib.mirrorFunctionArgs consumer (args: {
    first = consumer args;
    second = consumer (args // { label = "second"; });
  })) { };

  # Explicit arguments may be consumed through an argument alias or a plain
  # function parameter, so they cannot be filtered by functionArgs again.
  preservesExplicitArgs =
    f:
    let
      member = (callPackages f { extra = "explicit"; }).member;
    in
    member.value == "explicit"
    &&
      (member.override (old: {
        extra = old.extra + "-updated";
      })).value == "explicit-updated";

  # Comparing the resulting derivations checks selection of both the BUILD
  # compiler and HOST runtime. Merely checking versions would miss a grouped
  # package receiving an unspliced HOST compiler as a native build input.
  same =
    label: actual: expected:
    lib.assertMsg (actual.drvPath == expected.drvPath) "CUDA scope: ${label}";
in
assert same "callPackages must use callPackage's spliced arguments" grouped.first individual;
assert same "each group member must retain its own arguments" grouped.second (
  individual.override { label = "second"; }
);
assert same "group member overrides must re-evaluate the member" (grouped.first.override {
  label = "override";
}) (individual.override { label = "override"; });
assert same "callPackages explicit arguments must override defaults" ((callPackages
  (lib.mirrorFunctionArgs consumer (args: {
    first = consumer args;
  }))
  {
    label = "explicit";
  }
).first
) (individual.override { label = "explicit"; });
assert lib.assertMsg (preservesExplicitArgs (args: {
  member.value = args.extra or "missing";
})) "CUDA scope: generic grouped functions and their overrides must retain explicit arguments";
assert lib.assertMsg (preservesExplicitArgs (
  args@{ cudaNamePrefix, ... }:
  {
    member.value = args.extra or "missing";
  }
)) "CUDA scope: ellipsis grouped functions and their overrides must retain explicit arguments";
# These are evaluation assertions: no CUDA compiler or runtime needs building.
runCommand "${cudaNamePrefix}-tests-scope" { } ''
  touch "$out"
''
