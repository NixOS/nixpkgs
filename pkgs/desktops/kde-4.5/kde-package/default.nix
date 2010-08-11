{ stdenv, fetchurl }:

let
  manifest = import ./manifest.nix;
in

a@{ pn, v, stable ? true, subdir ? null, ... }:
stdenv.mkDerivation ({
  name = "${pn}-${v}";
  src = fetchurl {
    url = "mirror://kde/" + (if stable then "" else "un") + "stable/" +
      (if subdir == null then "${v}/src" else subdir) + "/${pn}-${v}.tar.bz2";
    sha256 = builtins.getAttr "${pn}-${v}.tar.bz2" manifest;
  };
  meta = {
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    platforms = stdenv.lib.platforms.linux;
    inherit stable;
    homepage = http://www.kde.org;
  } // ( if a ? meta then a.meta else { } );
} // (removeAttrs a [ "meta" "pn" "v" "stable" "subdir" ]))
