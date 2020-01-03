{ enableX11 ? true
,  stdenv, fetchurl, pkgconfig, xorg }:

stdenv.mkDerivation rec {
  pname = "frame";
  version = "2.5.0";
  src = fetchurl {
    url = "https://launchpad.net/frame/trunk/v${version}/+download/${pname}-${version}.tar.xz";
    sha256 = "bc2a20cd3ac1e61fe0461bd3ee8cb250dbcc1fa511fad0686d267744e9c78f3a";
  };

  buildInputs = [ 
    stdenv pkgconfig
  ] ++ stdenv.lib.optionals enableX11 [xorg.xorgserver xorg.libX11 xorg.libXext xorg.libXi];

  configureFlags = stdenv.lib.optional enableX11 "--with-x11";

  meta = {
    homepage = https://launchpad.net/frame;
    description = "Handles the buildup and synchronization of a set of simultaneous touches";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
