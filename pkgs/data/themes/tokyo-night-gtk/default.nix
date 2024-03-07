{ lib
, callPackage
, runCommand
, gtk-engine-murrine
, gnome-themes-extra
}:

let
  prefix = "tokyo-night-gtk";

  packages = lib.mapAttrs' (type: content: {
    name = type;

    value = lib.mapAttrs' (variantName: variant: {
      name = variantName;
      value = callPackage ./generic.nix { inherit prefix type variantName variant; };
    }) content;
  }) (lib.importJSON ./variants.json);
in packages // {
  # Not using `symlinkJoin` because it's massively inefficient in this case
  full = runCommand "${prefix}_full" {
    preferLocalBuild = true;

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
      gnome-themes-extra
    ];
  } ''
    mkdir -p $out/share/{icons,themes,${prefix}}

    ${lib.concatStrings (lib.forEach (lib.attrValues (lib.attrsets.mergeAttrsList (lib.attrValues packages))) (variant:
      ''
        ln -s ${variant}/share/${variant.ptype}/Tokyonight-${variant.pvariant} $out/share/${variant.ptype}/Tokyonight-${variant.pvariant}
        ln -s ${variant}/share/${prefix}/LICENSE $out/share/${prefix}/LICENSE 2>/dev/null || true
      ''
    ))}
  '';
}
