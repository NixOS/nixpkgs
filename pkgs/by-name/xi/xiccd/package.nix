{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libXrandr,
  glib,
  colord,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xiccd";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "agalakhov";
    repo = "xiccd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-inDSW+GYvSw2hNMzjq3cxEvY+Vkqmmm2kXdhskvcygU=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "m4_esyscmd_s([git describe --abbrev=7 --dirty --always --tags])" "${finalAttrs.version}" \
      --replace-fail "AM_INIT_AUTOMAKE([1.9 no-dist-gzip dist-xz tar-ustar])" "AM_INIT_AUTOMAKE([foreign 1.9 no-dist-gzip dist-xz tar-ustar])"
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libXrandr
    glib
    colord
  ];

  meta = {
    description = "X color profile daemon";
    homepage = "https://github.com/agalakhov/xiccd";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "xiccd";
  };
})
