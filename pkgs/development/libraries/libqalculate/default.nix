{ stdenv, fetchurl, cln, libxml2, glib, intltool, pkgconfig, doxygen, autoreconfHook, readline }:

stdenv.mkDerivation rec {
  name = "libqalculate-${version}";
  version = "1.0.0a";

  src = fetchurl {
    url = "https://github.com/Qalculate/libqalculate/archive/v${version}.tar.gz";
    sha256 = "12igmd1rn6zwrsg0mmn5pwy2bqj2gmc08iry0vcdxgzi7jc9x7ix";
  };

  outputs = [ "out" "dev" "doc" ];

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
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
