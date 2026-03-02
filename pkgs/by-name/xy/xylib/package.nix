{
  lib,
  stdenv,
  fetchurl,
  boost,
  zlib,
  bzip2,
  wxGTK32,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xylib";
  version = "1.6";

  src = fetchurl {
    url = "https://github.com/wojdyr/xylib/releases/download/v${finalAttrs.version}/xylib-${finalAttrs.version}.tar.bz2";
    sha256 = "1iqfrfrk78mki5csxysw86zm35ag71w0jvim0f12nwq1z8rwnhdn";
  };

  buildInputs = [
    boost
    zlib
    bzip2
    wxGTK32
  ];

  configureFlags = [
    "--with-wx-config=${lib.getExe' (lib.getDev wxGTK32) "wx-config"}"
  ];

  meta = {
    description = "Portable library for reading files that contain x-y data from powder diffraction, spectroscopy and other experimental methods";
    license = lib.licenses.lgpl21;
    homepage = "https://xylib.sourceforge.net/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
