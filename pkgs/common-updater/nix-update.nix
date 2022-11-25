{ lib
, nix-update
}:

{ attrPath
# Regex to extract version with, i.e. "jq-(.*)"
, versionRegex ? null
}:

[ "${nix-update}/bin/nix-update" ] ++
lib.optionals (versionRegex != null) [ "-vr" versionRegex ] ++
[ attrPath ]
