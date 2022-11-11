{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config

# for passthru.tests
, imagemagick
, imagemagick6
, libheif
, imlib2Full
, gst_all_1
}:

stdenv.mkDerivation rec {
  version = "1.0.9";
  pname = "libde265";

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libde265";
    rev = "v${version}";
    sha256 = "sha256-OpiQapppuKCR27tIG5OW+KiNMP9ysv7CaobiBOW6VUI=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit imagemagick imagemagick6 libheif imlib2Full;
    inherit (gst_all_1) gst-plugins-bad;
  };

  meta = {
    homepage = "https://github.com/strukturag/libde265";
    description = "Open h.265 video codec implementation";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
