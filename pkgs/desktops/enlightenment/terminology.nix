{ stdenv, fetchurl, pkgconfig, efl, curl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.xz";
    sha256 = "13rl1k22yf8qrpzdm5nh6ij641fibadr2ww1r7rnz7mbhzj3d4gb";
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
