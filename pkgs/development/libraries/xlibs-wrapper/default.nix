{stdenv, packages}:

stdenv.mkDerivation {
  name = "xlibs-wrapper";

  dontBuild = true;

  installPhase = "mkdir -p $out";
  unpackPhase = "sourceRoot=.";

  propagatedBuildInputs = packages;

  preferLocalBuild = true;
} // {
  # For compatability with XFree86.
  buildClientLibs = true;
}
