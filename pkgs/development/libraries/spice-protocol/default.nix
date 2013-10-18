{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "spice-protocol-0.12.6";

  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "16r5x2sppiaa6pzawkrvk5q4hmw7ynmlp2xr38f1vaxj5rh4aiwx";
  };

  meta = {
    description = "Protocol headers for the SPICE protocol";
    homepage = http://www.spice-space.org;
    license = stdenv.lib.licenses.bsd3;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
