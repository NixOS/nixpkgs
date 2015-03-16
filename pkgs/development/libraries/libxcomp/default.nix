{ stdenv, fetchurl, autoconf, libjpeg, libpng12, libX11, zlib }:

let version = "3.5.0.30"; in
stdenv.mkDerivation {
  name = "libxcomp-${version}";

  src = fetchurl {
    url = "http://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-full.tar.gz";
    sha256 = "0npwlfv9p5fwnf30fpkfw08mq11pgbvp3d2zgnhh8ykf3yj8dgv0";
  };

  meta = with stdenv.lib; {
    description = "NX compression library";
    homepage = "http://wiki.x2go.org/doku.php/wiki:libs:nx-libs";
    license = with licenses; gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ autoconf libjpeg libpng12 libX11 zlib ];

  preConfigure = ''
    cd nxcomp/
    autoconf
  '';

  enableParallelBuilding = true;

  postInstall = ''
    mkdir $out/lib
    cp libXcomp.so* $out/lib
    mkdir $out/include
    cp NX.h $out/include
  '';
}
