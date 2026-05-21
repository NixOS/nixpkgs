{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  harfbuzz,
  libpng,
  libxcb-util,
  libxcursor,
  libxcb-image,
  libxkbcommon,
  libxcb-cursor,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmoji";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "Zirias";
    repo = "xmoji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uYynbzexj1MDHcU8tryJLCGmqTfYOmY0vXrHZ3MlZa0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace zimk/lib/platform.mk \
      --replace-fail 'PATH:=''$(POSIXPATH)' "#"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    harfbuzz
    libxcursor
    libpng
    libxkbcommon
    libxcb-cursor
    libxcb-util
    libxcb-image
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    description = "Plain X11 emoji keyboard";
    homepage = "https://github.com/Zirias/xmoji";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux;
  };
})
