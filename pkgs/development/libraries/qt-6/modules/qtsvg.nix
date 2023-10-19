{ qtModule
, qtbase
, libwebp
, jasper
, libmng
, zlib
, pkg-config
, fetchpatch2
}:

qtModule {
  pname = "qtsvg";
  qtInputs = [ qtbase ];
  buildInputs = [ libwebp jasper libmng zlib ];
  nativeBuildInputs = [ pkg-config ];
  patches = [
    # Fix nullptr dereference with invalid SVG
    # https://bugreports.qt.io/projects/QTBUG/issues/QTBUG-117944
    (fetchpatch2 {
      name = "QTBUG-117944.patch";
      url = "https://code.qt.io/cgit/qt/qtsvg.git/patch/?id=edc8ca7f";
      hash = "sha256-kBQYlQqPb0QkRhatQyaGdxE1Y5zHd6/ZEd5zn0gRVoM=";
    })
  ];
}
