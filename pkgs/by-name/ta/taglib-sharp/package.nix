{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  which,
  pkg-config,
  mono,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taglib-sharp";
  version = "2.1.0.0";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "taglib-sharp";
    rev = "taglib-sharp-${finalAttrs.version}";
    sha256 = "12pk4z6ag8w7kj6vzplrlasq5lwddxrww1w1ya5ivxrfki15h5cp";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    which
  ];
  buildInputs = [ mono ];

  dontStrip = true;

  configureFlags = [ "--disable-docs" ];

  meta = {
    description = "Library for reading and writing metadata in media files";
    homepage = "https://github.com/mono/taglib-sharp";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
  };
})
