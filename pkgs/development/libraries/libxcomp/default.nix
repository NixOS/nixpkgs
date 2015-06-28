{ stdenv, fetchurl, autoreconfHook, libjpeg, libpng12, libX11, zlib }:

let version = "3.5.0.31"; in
stdenv.mkDerivation {
  name = "libxcomp-${version}";

  src = fetchurl {
    sha256 = "1hi3xrjzr37zs72djw3k7gj6mn2bsihfw1iysl8l0i85jl6sdfkd";
    url = "http://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-lite.tar.gz";
  };

  meta = with stdenv.lib; {
    description = "NX compression library";
    homepage = "http://wiki.x2go.org/doku.php/wiki:libs:nx-libs";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ libjpeg libpng12 libX11 zlib ];
  nativeBuildInputs = [ autoreconfHook ];

  preAutoreconf = ''
    cd nxcomp/
  '';

  enableParallelBuilding = true;

  postInstall = ''
    mkdir $out/lib
    cp libXcomp.so* $out/lib
    mkdir $out/include
    cp NX.h $out/include
  '';
}
