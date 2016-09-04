{ stdenv, fetchurl, cln, libxml2, glib, intltool, pkgconfig, doxygen, autoreconfHook, readline }:

stdenv.mkDerivation rec {
  name = "libqalculate-${version}";
  version = "0.9.9";

  src = fetchurl {
    url = "https://github.com/Qalculate/libqalculate/archive/v${version}.tar.gz";
    sha256 = "0avri5c3sr31ax0vjvzla1a11xb4irnrc6571lm6w4zxigqakkqk";
  };

  nativeBuildInputs = [ intltool pkgconfig autoreconfHook doxygen ];
  buildInputs = [ readline ];
  propagatedBuildInputs = [ cln libxml2 glib ];

  preBuild = ''
    pushd docs/reference
    doxygen Doxyfile
    popd
  '';

  meta = with stdenv.lib; {
    description = "An advanced calculator library";
    homepage = http://qalculate.github.io;
    maintainers = with maintainers; [ urkud gebner ];
    platforms = platforms.all;
  };
}
