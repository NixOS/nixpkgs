{stdenv, packages}:

stdenv.mkDerivation {
  name = "xlibs-wrapper";
  builder = ./builder.sh;
  propagatedBuildInputs = packages;
} // {
  # For compatability with XFree86.
  buildClientLibs = true;
}
