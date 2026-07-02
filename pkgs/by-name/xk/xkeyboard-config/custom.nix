# xkeyboard-config variant extensible with custom layouts.
# See nixos/modules/services/x11/extra-layouts.nix
{
  lib,
  xkeyboard-config,
  automake,
  ed,
}:
{
  layouts ? { },
}:
let
  patchIn = name: layout: ''
    # install layout files
    ${lib.optionalString (layout.compatFile != null) "cp '${layout.compatFile}' 'compat/${name}'"}
    ${lib.optionalString (layout.geometryFile != null) "cp '${layout.geometryFile}' 'geometry/${name}'"}
    ${lib.optionalString (layout.keycodesFile != null) "cp '${layout.keycodesFile}' 'keycodes/${name}'"}
    ${lib.optionalString (layout.symbolsFile != null) "cp '${layout.symbolsFile}' 'symbols/${name}'"}
    ${lib.optionalString (layout.typesFile != null) "cp '${layout.typesFile}' 'types/${name}'"}

    # add model description
    ${ed}/bin/ed -v rules/base.xml <<EOF
    /<\/modelList>
    -
    a
    <model>
      <configItem>
        <name>${name}</name>
        <description>${layout.description}</description>
        <vendor>${layout.description}</vendor>
      </configItem>
    </model>
    .
    w
    EOF

    # add layout description
    ed -v rules/base.xml <<EOF
    /<\/layoutList>
    -
    a
    <layout>
      <configItem>
        <name>${name}</name>
        <shortDescription>${name}</shortDescription>
        <description>${layout.description}</description>
        <languageList>
          ${lib.concatMapStrings (lang: "<iso639Id>${lang}</iso639Id>\n") layout.languages}
        </languageList>
      </configItem>
      <variantList/>
    </layout>
    .
    w
    EOF
  '';
in
xkeyboard-config.overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [
    automake
    ed
  ];
  postPatch = lib.concatStrings (lib.mapAttrsToList patchIn layouts);
})
