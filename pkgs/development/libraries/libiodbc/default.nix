{ config, stdenv, fetchurl, pkgconfig, gtk2, Carbon
, useGTK ? config.libiodbc.gtk or false }:

stdenv.mkDerivation rec {
  name = "libiodbc-3.52.12";

  src = fetchurl {
    url = "mirror://sourceforge/iodbc/${name}.tar.gz";
    sha256 = "0qpvklgr1lcn5g8xbz7fbc9rldqf9r8s6xybhqj20m4sglxgziai";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = stdenv.lib.optionals useGTK [ gtk2 ]
                ++ stdenv.lib.optional stdenv.isDarwin Carbon;

  preBuild =
    ''
      export NIX_LDFLAGS_BEFORE="-rpath $out/lib"
    '';

  meta = with stdenv.lib; {
    description = "iODBC driver manager";
    homepage = http://www.iodbc.org;
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
