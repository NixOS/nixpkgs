{stdenv, packages}:

stdenv.mkDerivation {
  name = "xlibs-wrapper";
  buildPhase = "true";
  installPhase = "ensureDir $out";
  unpackPhase = "sourceRoot=.";
  propagatedBuildInputs = packages;
} // {
  # For compatability with XFree86.
  buildClientLibs = true;
}
