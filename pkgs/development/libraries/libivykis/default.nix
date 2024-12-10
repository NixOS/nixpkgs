{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  file,
  protobufc,
}:

stdenv.mkDerivation rec {
  pname = "libivykis";

  version = "0.42.4";

  src = fetchurl {
    url = "mirror://sourceforge/libivykis/${version}/ivykis-${version}.tar.gz";
    sha256 = "0abi0rc3wnncvr68hy6rmzp96x6napd7fs1mff20dr8lb0jyvy3f";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    file
    protobufc
  ];

  meta = with lib; {
    homepage = "https://libivykis.sourceforge.net/";
    description = ''
      A thin wrapper over various OS'es implementation of I/O readiness
      notification facilities
    '';
    license = licenses.zlib;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
