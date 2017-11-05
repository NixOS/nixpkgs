{pkgs, system, nodejs}:

let
  nodePackages = import ./composition-v4.nix {
    inherit pkgs system nodejs;
  };
in
nodePackages // {
  node-inspector = nodePackages.node-inspector.override (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ nodePackages.node-pre-gyp ];
  });
}
