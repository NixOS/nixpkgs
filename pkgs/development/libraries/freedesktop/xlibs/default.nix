{stdenv, libX11, libXt}:

stdenv.mkDerivation {
  name = "xlib-1.0";
  builder = ./builder.sh;
  propagatedBuildInputs = [libX11 libXt];
} // {
  # For compatability with XFree86.
  buildClientLibs = true;
}
