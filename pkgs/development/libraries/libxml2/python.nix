# slightly hacky
{ buildEnv, libxml2 }:

buildEnv {
  name = "libxml2+py-${libxml2.version}";
  paths = with libxml2; [ dev bin py ];
  inherit (libxml2) passthru;
  # the hook to find catalogs is hidden by buildEnv
  postBuild = ''
    mkdir "$out/nix-support"
    cp '${libxml2.dev}/nix-support/propagated-build-inputs' "$out/nix-support/"
  '';
}
