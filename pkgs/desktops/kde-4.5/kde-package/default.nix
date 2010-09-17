{ stdenv, fetchurl }:

rec {
  manifest = import ./manifest.nix;

  kdeSrc = { stable ? true, subdir ? null, module, release, sha256 ? null } :
    fetchurl {
      url = "mirror://kde/" + (if stable then "" else "un") + "stable/"
        + (if subdir == null then "${release}/src" else subdir)
        + "/${module}-${release}.tar.bz2";
      sha256 =
        if sha256 != null then sha256
        else builtins.getAttr "${module}-${release}.tar.bz2" manifest;
    };

  defaultArgs = {name, stable ? true, subdir ? null, version,
    module ? name, release ? version, ... }:

    assert (name == module) -> (release == version);

    (
      {
        name = "${name}-${version}";

        src = kdeSrc { inherit stable subdir module release; };

        meta = {
          maintainers = with stdenv.lib.maintainers; [ sander urkud ];
          platforms = stdenv.lib.platforms.linux;
          homepage = if name == module
            then http://www.kde.org
            else assert builtins.substring 0 3 module == "kde";
              "http://"
              + builtins.substring 3
                (builtins.sub (builtins.stringLength module) 3) module
              + ".kde.org/projects/${name}";
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
