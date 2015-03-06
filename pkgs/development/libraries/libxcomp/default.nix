{ stdenv, fetchgit, autoconf, libjpeg, libpng12, libX11, zlib }:

let version = "3.5.0-2015-02-18"; in
stdenv.mkDerivation {
  name = "libxcomp-${version}";

  src = fetchgit {
    url = git://code.x2go.org/nx-libs.git;
    rev = "2b2a02f93f552a38de8f72a971fa3f3ff42b3298";
    sha256 = "11n7dv1cn9icjgyxmsbac115vmbaar47cmp8k76vd516f2x41dw9";
  };

  meta = with stdenv.lib; {
    description = "NX compression library";
    homepage = "http://code.x2go.org/gitweb?p=nx-libs.git;a=summary";
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
