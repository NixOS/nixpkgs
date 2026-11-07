{
  qtModule,
  qtbase,
  libwebp,
  jasper,
  libmng,
  zlib,
  lib,
  stdenv,
}:

qtModule {
  pname = "qtsvg";
  propagatedBuildInputs = [ qtbase ];
  buildInputs = [
    libwebp
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    jasper
  ]
  ++ [
    libmng
    zlib
  ];
}
