{stdenv, libX11, libXt, freetype, fontconfig, libXft, libXext}:

stdenv.mkDerivation {
  name = "xlib-1.0";
  builder = ./builder.sh;
  propagatedBuildInputs = [libX11 libXt freetype fontconfig libXft libXext];
} // {
  # For compatability with XFree86.
  buildClientLibs = true;
}
