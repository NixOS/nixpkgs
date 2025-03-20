{
  lib,
  stdenv,
  fetchurl,
  qmake,
}:

stdenv.mkDerivation rec {
  version = "3.26.4";
  pname = "dxflib";
  src = fetchurl {
    url = "https://qcad.org/archives/dxflib/${pname}-${version}-src.tar.gz";
    sha256 = "0pwic33mj6bp4axai5jiyn4xqf31y0xmb1i0pcf55b2h9fav8zah";
  };
  nativeBuildInputs = [
    qmake
  ];
  dontWrapQtApps = true;
  preConfigure = ''
    sed -i 's/CONFIG += staticlib/CONFIG += shared/' dxflib.pro
  '';
  installPhase = ''
    install -d -m 0755 $out/lib
    cp -pr *${stdenv.hostPlatform.extensions.sharedLibrary}* $out/lib
    install -d -m 0755 $out/include/dxflib
    cp -pr src/*.h $out/include/dxflib
    # Generate pkg-config file
    install -d -m 0755 $out/lib/pkgconfig
    cat << 'EOF' > $out/lib/pkgconfig/dxflib.pc
    prefix=${placeholder "out"}
    libdir=${placeholder "out"}/lib
    includedir=${placeholder "out"}/include
    Name: dxflib
    Description: A C++ library for reading and writing DXF files
    Version: %{version}
    Libs: -L${placeholder "out"}/lib -ldxflib
    Cflags: -I${placeholder "out"}/include/dxflib
    EOF
  '';
  doCheck = true;

  meta = {
    homepage = "https://qcad.org/en/90-dxflib";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    description = "DXF file format library";
  };
}
