{ stdenv, fetchgit, pkgconfig, xfce4-dev-tools, hicolor-icon-theme, xfce, wrapGAppsHook }:

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
  inherit (stdenv.lib) attrNames concatLists recursiveUpdate zipAttrsWithNames;

  filterAttrNames = f: attrs:
    filter (n: f (getAttr n attrs)) (attrNames attrs);

  concatAttrLists = attrsets:
    zipAttrsWithNames (filterAttrNames isList (head attrsets)) (_: concatLists) attrsets;

  template = rec {
    name = "${pname}-${version}";

    nativeBuildInputs = [ pkgconfig xfce4-dev-tools wrapGAppsHook ];
    buildInputs = [ hicolor-icon-theme ];
    configureFlags = [ "--enable-maintainer-mode" ];

    src = fetchgit {
      url = "git://git.xfce.org/${category}/${pname}";
      inherit rev sha256;
    };

    enableParallelBuilding = true;
    outputs = [ "out" "dev" ];

    pos = builtins.unsafeGetAttrPos "pname" args;

    passthru.updateScript = xfce.updateScript {
      inherit pname version attrPath rev-prefix odd-unstable patchlevel-unstable;
      versionLister = xfce.gitLister src.url;
    };

    meta = with stdenv.lib; {
      homepage = "https://git.xfce.org/${category}/${pname}/about";
      license = licenses.gpl2; # some libraries are under LGPLv2+
      platforms = platforms.linux;
    };
  };

  publicArgs = removeAttrs args [ "category" "pname" "sha256" ];
in

stdenv.mkDerivation (recursiveUpdate template publicArgs // concatAttrLists [ template args ])
