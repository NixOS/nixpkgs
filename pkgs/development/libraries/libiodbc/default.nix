{ config, lib, stdenv, fetchurl, pkg-config, gtk2, Carbon
, useGTK ? config.libiodbc.gtk or false }:

stdenv.mkDerivation rec {
  pname = "libiodbc";
  version = "3.52.15";

  src = fetchurl {
    url = "mirror://sourceforge/iodbc/${pname}-${version}.tar.gz";
    sha256 = "sha256-x0VB4zJ/yaHHzPEDZFRxxnvAFFQtcPVyR26wfAst1Dw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals useGTK [ gtk2 ]
                ++ lib.optional stdenv.isDarwin Carbon;

  preBuild =
    ''
      export NIX_LDFLAGS_BEFORE="-rpath $out/lib"
    '';

  meta = with lib; {
    description = "iODBC driver manager";
    homepage = "http://www.iodbc.org";
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
