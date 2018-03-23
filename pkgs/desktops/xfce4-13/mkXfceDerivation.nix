{ stdenv, fetchgit, pkgconfig, xfce4-dev-tools ? null }:

{ category, pname, sha256 ? null, version, ... } @ args:

let
  inherit (builtins) filter getAttr head isList;
  inherit (stdenv.lib) attrNames concatLists recursiveUpdate zipAttrsWithNames;

  filterAttrNames = f: attrs:
    filter (n: f (getAttr n attrs)) (attrNames attrs);

  concatAttrLists = attrsets:
    zipAttrsWithNames (filterAttrNames isList (head attrsets)) (_: concatLists) attrsets;

  template = rec {
    name = "${pname}-${version}";

    nativeBuildInputs = [ pkgconfig xfce4-dev-tools ];
    configureFlags = [ "--enable-maintainer-mode" ];

    src = fetchgit {
      url = "git://git.xfce.org/${category}/${pname}";
      rev = name;
      inherit sha256;
    };

    enableParallelBuilding = true;
    outputs = [ "out" "dev" ];

    meta = with stdenv.lib; {
      homepage = "https://git.xfce.org/${category}/${pname}/about";
      license = licenses.gpl2; # some libraries are under LGPLv2+
      platforms = platforms.linux;
    };
  };

  publicArgs = removeAttrs args [ "category" "pname" "sha256" ];
in

stdenv.mkDerivation (recursiveUpdate template publicArgs // concatAttrLists [ template args ])
