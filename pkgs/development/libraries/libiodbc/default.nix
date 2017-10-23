{ stdenv, fetchurl, pkgconfig, gtk2, useGTK ? false }:

stdenv.mkDerivation rec {
  name = "libiodbc-3.52.8";

  src = fetchurl {
    url = "mirror://sourceforge/iodbc/${name}.tar.gz";
    sha256 = "16hjb6fcval85gnkgkxfhw4c5h3pgf86awyh8p2bhnnvzc0ma5hq";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = stdenv.lib.optionals useGTK [ gtk2 ];

  preBuild =
    ''
      export NIX_LDFLAGS_BEFORE="-rpath $out/lib"
    '';

  meta = {
    description = "iODBC driver manager";
    homepage = http://www.iodbc.org;
    platforms = stdenv.lib.platforms.linux;
  };
}
