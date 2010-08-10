{ stdenv, fetchurl }:

a@{ pn, v, stable ? true, sha256, subdir ? null, ... }:
stdenv.mkDerivation ({
  name = "${pn}-${v}";
  src = fetchurl {
    url = "mirror://kde/" + (if stable then "" else "un") + "stable/" +
      (if subdir == null then "${v}/src" else subdir) + "/${pn}-${v}.tar.bz2";
    inherit sha256;
  };
  meta = {
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    platforms = stdenv.lib.platforms.linux;
    inherit stable;
    homepage = http://www.kde.org;
  } // ( if a ? meta then a.meta else { } );
} // (removeAttrs a [ "meta" "pn" "v" "stable" "sha256" "subdir" ]))
