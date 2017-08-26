{ stdenv, fetchurl, pkgconfig, efl, curl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.xz";
    sha256 = "1x4j2q4qqj10ckbka0zaq2r2zm66ff1x791kp8slv1ff7fw45vdz";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ efl curl ];

  NIX_CFLAGS_COMPILE = [
    "-I${efl}/include/ecore-con-1"
    "-I${efl}/include/eldbus-1"
    "-I${efl}/include/elocation-1"
    "-I${efl}/include/emile-1"
    "-I${efl}/include/eo-1"
    "-I${efl}/include/ethumb-1"
  ];

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix LD_LIBRARY_PATH : ${curl.out}/lib
    done
  '';

  meta = {
    description = "The best terminal emulator written with the EFL";
    homepage = http://enlightenment.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
  };
}
