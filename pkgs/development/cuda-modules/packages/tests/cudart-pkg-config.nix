{
  cccl,
  cuda_cudart,
  cuda_crt,
  lib,
  tests,
}:
let
  consumer = runtime: (tests.pkg-config.override { cuda_cudart = runtime; }).tests.cudart;
in
(consumer cuda_cudart).overrideAttrs {
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
          passthru = lib.recursiveUpdate old.passthru {
            outputToPatterns.${output} = [ "include" ];
          };
        });
    in
    consumer (
      cuda_cudart.override {
        cuda_crt = headersInOutput cuda_crt;
        cccl = headersInOutput cccl;
      }
    )
  );
}
