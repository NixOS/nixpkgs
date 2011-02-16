{ stdenv, fetchurl, release }:

rec {
  inherit release;

  manifest = import (./manifest + "-${release}.nix");

  defaultArgs = { module, name ? module, ... }:

    (
      {
        name = "${name}-${release}";

        src = fetchurl {
          url = "mirror://kde/" + (if manifest.stable then "" else "un")
            + "stable/${release}/src/${module}-${release}.tar.bz2";
          sha256 = builtins.getAttr module manifest.packages;
        };

        meta = {
          maintainers = with stdenv.lib.maintainers; [ sander urkud ];
          platforms = stdenv.lib.platforms.linux;
        };
      } // (if module == name then { } else {
        cmakeFlags = ''
          -DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=TRUE
          -DBUILD_doc=TRUE -DBUILD_${name}=TRUE'';
      })
    );

  package = a@{meta, ...}:
    assert a.meta ? kde;
    let
      default = defaultArgs a.meta.kde;
    in
# hand-written merge
    stdenv.mkDerivation (
      default
        // removeAttrs a [ "meta" "cmakeFlags" ]
        // {
          meta = default.meta // a.meta;
        }
        // (if default ? cmakeFlags || a ? cmakeFlags then {
          cmakeFlags =
            (if default ? cmakeFlags then "${default.cmakeFlags}" else "")
            + (if default ? cmakeFlags && a ? cmakeFlags then " " else "")
            + (if a ? cmakeFlags then a.cmakeFlags else "");
        } else { }
      ));
}
