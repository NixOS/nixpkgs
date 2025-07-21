{ zlib }: prevAttrs: { buildInputs = prevAttrs.buildInputs or [ ] ++ [ zlib ]; }
