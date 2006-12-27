{stdenv, packages}:

stdenv.mkDerivation {
  name = "xlibs-wrapper";
  buildPhase = "true";
  installPhase = "true";
  unpackPhase = "sourceRoot=.";
  propagatedBuildInputs = packages;
} // {
  # For compatability with XFree86.
  buildClientLibs = true;
}
