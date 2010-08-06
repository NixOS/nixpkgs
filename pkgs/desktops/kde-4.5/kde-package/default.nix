{ stdenv, fetchurl }:

{ pn, v, stable ? true, sha256, subdir ? null }: args:
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
  } // ( if args ? meta then args.meta else { } );
} // args)
