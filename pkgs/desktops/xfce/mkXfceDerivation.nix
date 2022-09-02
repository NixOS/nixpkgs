{ lib, stdenv, fetchFromGitLab, pkg-config, xfce4-dev-tools, hicolor-icon-theme, xfce, wrapGAppsHook, gitUpdater }:

{ category
, pname
, version
, attrPath ? "xfce.${pname}"
, rev-prefix ? "${pname}-"
, rev ? "${rev-prefix}${version}"
, sha256
, odd-unstable ? true
, patchlevel-unstable ? true
, ...
} @ args:

let
  inherit (builtins) filter getAttr head isList;
  inherit (lib) attrNames concatLists recursiveUpdate zipAttrsWithNames;

  filterAttrNames = f: attrs:
    filter (n: f (getAttr n attrs)) (attrNames attrs);

  concatAttrLists = attrsets:
    zipAttrsWithNames (filterAttrNames isList (head attrsets)) (_: concatLists) attrsets;

  template = rec {
    inherit pname version;

    nativeBuildInputs = [ pkg-config xfce4-dev-tools wrapGAppsHook ];
    buildInputs = [ hicolor-icon-theme ];
    configureFlags = [ "--enable-maintainer-mode" ];

    src = fetchFromGitLab {
      domain = "gitlab.xfce.org";
      owner = category;
      repo = pname;
      inherit rev sha256;
    };

    enableParallelBuilding = true;
    outputs = [ "out" "dev" ];

    pos = builtins.unsafeGetAttrPos "pname" args;

    passthru.updateScript = gitUpdater {
      inherit pname version attrPath rev-prefix odd-unstable patchlevel-unstable;
    };

    meta = with lib; {
      homepage = "https://gitlab.xfce.org/${category}/${pname}";
      license = licenses.gpl2Plus; # some libraries are under LGPLv2+
      platforms = platforms.linux;
    };
  };

  publicArgs = removeAttrs args [ "category" "pname" "sha256" ];
in

stdenv.mkDerivation (recursiveUpdate template publicArgs // concatAttrLists [ template args ])
# TODO [ AndersonTorres ]: verify if it allows using hash attribute as an option to sha256
