{ stdenv
, fetchurl
, gmp
}:
# will probably be obsolte (or at leat built from the upstream gap sources) soon (gap 4.9?). See
# - https://github.com/gap-system/gap/projects/5#card-6239828
# - https://github.com/markuspf/gap/issues/2
# - https://trac.sagemath.org/ticket/22626
stdenv.mkDerivation rec {
  pname = "libgap";
  # Has to be the same version as "gap"
  version = "4.8.6";
  src = fetchurl {
    url = "mirror://sageupstream/libgap/libgap-${version}.tar.gz";
    sha256 = "1h5fx5a55857w583ql7ly2jl49qyx9mvs7j5abys00ra9gzrpn5v";
  };
  buildInputs = [gmp];
  meta = {
    inherit version;
    description = ''A library-packaged fork of the GAP kernel'';
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
