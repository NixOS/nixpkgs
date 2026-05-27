{
  lib,
  qtModule,
  qtbase,
  libwebp,
  jasper,
  libmng,
  libtiff,
}:

qtModule {
  pname = "qtimageformats";
  propagatedBuildInputs = [
    qtbase
    libwebp
  ]
  ++ lib.optionals (!jasper.meta.broken) [
    jasper
  ]
  ++ [
    libmng
    libtiff
  ];
}
