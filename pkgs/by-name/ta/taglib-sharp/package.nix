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
    hash = "sha256-lxVYQpwu9x2L8oEHznNvjdOCtaKZ3r+NnIejp8wn84o=";
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
