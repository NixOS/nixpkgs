{ cuda_cupti, lib }:
prevAttrs: {
  allowFHSReferences = true;
  buildInputs = prevAttrs.buildInputs ++ [ cuda_cupti ];
}
