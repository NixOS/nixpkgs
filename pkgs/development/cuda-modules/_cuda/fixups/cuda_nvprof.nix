{ cuda_cupti }: prevAttrs: { buildInputs = prevAttrs.buildInputs or [ ] ++ [ cuda_cupti ]; }
