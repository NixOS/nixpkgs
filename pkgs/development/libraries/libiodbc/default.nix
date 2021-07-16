{ config, lib, stdenv, fetchurl, pkg-config, gtk2, Carbon
, useGTK ? config.libiodbc.gtk or false }:

stdenv.mkDerivation rec {
  name = "libiodbc-3.52.14";

  src = fetchurl {
    url = "mirror://sourceforge/iodbc/${name}.tar.gz";
    sha256 = "sha256-9bflmYzgtt+gGbB+j2LofWq7oo/vnSrrkDA3yIOieTs=";
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
