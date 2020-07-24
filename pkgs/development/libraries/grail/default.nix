{ enableX11 ? true,
  stdenv, fetchurl, pkgconfig, xorg, python3, frame }:

stdenv.mkDerivation rec {
  pname = "grail";
  version = "3.1.1";

  src = fetchurl {
    url = "https://launchpad.net/grail/trunk/${version}/+download/${pname}-${version}.tar.bz2";
    sha256 = "1wwx5ibjdz5pyd0f5cd1n91y67r68dymxpm2lgd829041xjizvay";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python3 frame ]
  ++ stdenv.lib.optionals enableX11 [xorg.libX11 xorg.libXtst xorg.libXext xorg.libXi xorg.libXfixes];

  configureFlags = stdenv.lib.optional enableX11 "--with-x11";

  meta = {
    homepage = "https://launchpad.net/canonical-multitouch/grail";
    description = "Gesture Recognition And Instantiation Library";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
