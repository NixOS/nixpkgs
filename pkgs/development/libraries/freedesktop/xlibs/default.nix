{stdenv, libX11, libXt}:

derivation {
  name = "xlib-1.0";
  system = stdenv.system;
  builder = ./builder.sh;
  propagatedBuildInputs = [libX11 libXt];
  inherit stdenv;
} // {
  # For compatability with XFree86.
  buildClientLibs = true;
}
