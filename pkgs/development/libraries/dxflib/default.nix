{ lib, stdenv
, fetchurl
, qmake
}:

stdenv.mkDerivation rec {
  version = "3.17.0";
  pname = "dxflib";
  src = fetchurl {
    url = "http://www.qcad.org/archives/dxflib/${pname}-${version}-src.tar.gz";
    sha256 = "09yjgzh8677pzkkr7a59pql5d11451c22pxksk2my30mapxsri96";
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
    cp -pr *.so* $out/lib
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
    maintainers = with lib.maintainers; [raskin];
    platforms = lib.platforms.linux;
    description = "DXF file format library";
  };
}
