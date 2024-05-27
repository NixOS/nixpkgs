{ python3 }:

(python3.withPackages (_: [ python3.pkgs.qtile ])).overrideAttrs (_: {
  # restore some qtile attrs, beautify name
  inherit (python3.pkgs.qtile) pname version meta;
  name = with python3.pkgs.qtile; "${pname}-${version}";
  passthru.unwrapped = python3.pkgs.qtile;
})
