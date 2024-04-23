{ cuda_cupti, lib }:
let
  inherit (lib.attrsets) getLib;
in
prevAttrs: {
  allowFHSReferences = true;
  buildInputs = prevAttrs.buildInputs ++ [ (getLib cuda_cupti) ];
}
