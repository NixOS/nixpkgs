{ lib
, stdenv
, fetchurl
, cairo
, ffmpeg
, libexif
, pango
, pkg-config
, wxGTK
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) Cocoa;
in
stdenv.mkDerivation rec {
  pname = "wxSVG";
  version = "1.5.24";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxsvg/wxsvg/${version}/wxsvg-${version}.tar.bz2";
    hash = "sha256-rkcykfjQpf6voGzScMgmxr6tS86yud1vzs8tt8JeJII=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    ffmpeg
    libexif
    pango
    wxGTK
  ] ++ lib.optional stdenv.isDarwin Cocoa;

  meta = with lib; {
    homepage = "http://wxsvg.sourceforge.net/";
    description = "A SVG manipulation library built with wxWidgets";
    longDescription = ''
      wxSVG is C++ library to create, manipulate and render Scalable Vector
      Graphics (SVG) files with the wxWidgets toolkit.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    inherit (wxGTK.meta) platforms;
  };
}
