{ stdenv, lib, fetchurl, libX11, cubeExample ? true, mesa_glu}:

with lib;

stdenv.mkDerivation rec {
  version = "0.2.3";
  name = "libspnav-${version}";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/spacenav/${name}.tar.gz";
    sha256 = "14qzbzpfdb0dfscj4n0g8h8n71fcmh0ix2c7nhldlpbagyxxgr3s";
  };

  buildInputs = [ libX11 ] ++ stdenv.lib.optional cubeExample mesa_glu;

  configureFlags = [ "--disable-debug"];

  preInstall = "mkdir -p $out/{lib,include}";

  postInstall = optional cubeExample ''
    mkdir -p $out/bin
    cd examples/cube
    make
    mv cube $out/bin/libspnav-cube-example
  '';

  meta = {
    homepage = "http://spacenav.sourceforge.net/";
    description = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc).";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.flosse ];
  };
}
