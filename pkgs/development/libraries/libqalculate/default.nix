{ stdenv, fetchurl, cln, libxml2, glib, intltool, pkgconfig, doxygen, autoreconfHook, readline }:

stdenv.mkDerivation rec {
  name = "libqalculate-${version}";
  version = "0.9.8";

  src = fetchurl {
    url = "https://github.com/Qalculate/libqalculate/archive/v${version}.tar.gz";
    sha256 = "07rd95a0wsqs3iymr64mlljn191f8gdnjvr9d4l1spjv3s8j5wdi";
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
