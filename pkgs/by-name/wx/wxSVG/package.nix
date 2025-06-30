{
  lib,
  stdenv,
  fetchurl,
  cairo,
  expat,
  ffmpeg,
  libexif,
  pango,
  pkg-config,
  wxGTK32,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxsvg";
  version = "1.5.25";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxsvg/wxsvg/${finalAttrs.version}/wxsvg-${finalAttrs.version}.tar.bz2";
    hash = "sha256-W/asaDG1S9Ga70jN6PoFctu2PzCu6dUyP2vms/MmU0s=";
  };

  postPatch = ''
    # Apply upstream patch for gcc-13 support:
    #   https://sourceforge.net/p/wxsvg/git/ci/7b17fe365fb522618fb3520d7c5c1109b138358f/
    sed -i src/cairo/SVGCanvasCairo.cpp -e '1i #include <cstdint>'
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    expat
    ffmpeg
    libexif
    pango
    wxGTK32
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://wxsvg.sourceforge.net/";
    description = "SVG manipulation library built with wxWidgets";
    mainProgram = "svgview";
    longDescription = ''
      wxSVG is C++ library to create, manipulate and render Scalable Vector
      Graphics (SVG) files with the wxWidgets toolkit.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    inherit (wxGTK32.meta) platforms;
  };
})
