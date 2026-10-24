{ lib, python313Packages }:
with python313Packages;
(toPythonApplication vllm).overrideAttrs (
  finalAttrs: prevAttrs: {
    passthru = prevAttrs.passthru or { } // {
      services.default = {
        imports = [ (lib.modules.importApply ./service.nix { }) ];
        vllm.package = finalAttrs.finalPackage;
      };
    };
  }
)
