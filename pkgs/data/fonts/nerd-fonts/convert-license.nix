lib:
let
  ls = lib.licenses;
in
licenseString:
builtins.getAttr licenseString (
  (
    with builtins;
    lib.trivial.pipe (attrValues ls) [
      (filter (l: l ? spdxId))
      (map (l: lib.attrsets.nameValuePair l.spdxId l))
      listToAttrs
    ]
  )
  // {
    "Bitstream-Vera AND MIT" = with ls; [
      bitstreamVera
      mit
    ];
    "LicenseRef-Monofur" = ls.free; # upstream `src/unpatched-fonts/Monofur/LICENSE.txt`
    "LicenseRef-UbuntuFont" = ls.ufl;
    "LicenseRef-VicFieger" = ls.free; # upstream `src/unpatched-fonts/HeavyData/Vic Fieger License.txt`
    "MIT OR OFL-1.1-no-RFN" = ls.mit;
    "OFL-1.1-RFN" = ls.ofl;
    "OFL-1.1-no-RFN or LGPL-2.1-only" = ls.ofl;
    "OFL-1.1-no-RFN" = ls.ofl;
  }
)
