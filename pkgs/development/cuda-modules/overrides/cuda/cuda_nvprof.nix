{ cuda_cupti }:
prevAttrs: {
  allowFHSReferences = true;
  buildInputs = prevAttrs.buildInputs ++ [ cuda_cupti.lib ];
}
