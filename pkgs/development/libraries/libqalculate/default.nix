{ stdenv, fetchurl, cln, libxml2, glib, intltool, pkgconfig, doxygen, autoreconfHook, readline }:

stdenv.mkDerivation rec {
  name = "libqalculate-${version}";
  version = "0.9.10";

  src = fetchurl {
    url = "https://github.com/Qalculate/libqalculate/archive/v${version}.tar.gz";
    sha256 = "0whzc15nwsrib6bpw4lqsm59yr0pfk44hny9sivfbwhidk0177zi";
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
