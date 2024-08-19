{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  fontconfig,
  harfbuzz,
  libpng,
  xcbutil,
  libXcursor,
  xcbutilimage,
  libxkbcommon,
  xcb-util-cursor,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "xmoji";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Zirias";
    repo = "xmoji";
    rev =
      let
        inherit (lib.versions) majorMinor patch;
        inherit (finalAttrs) version;
      in
      "refs/tags/v${majorMinor version}-${patch version}";
    hash = "sha256-ZZ1jW97JUv003bAMZZfGWbAAPgeZlpBKREaedFi3R8M=";
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
    libXcursor
    libpng
    libxkbcommon
    xcb-util-cursor
    xcbutil
    xcbutilimage
  ];

  makeFlagsArray = [ "prefix=${placeholder "out"}" ];

  meta = {
    description = "Plain X11 emoji keyboard";
    homepage = "https://github.com/Zirias/xmoji";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux;
  };
})
