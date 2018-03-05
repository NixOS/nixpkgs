# This function provides specific bits for building a wheel-based Python package.

{
}:

{ ... } @ attrs:

attrs // {
  unpackPhase = ''
    mkdir dist
    wheel_filename="$(basename $src)"
    cp $src dist/"''${wheel_filename#*-}"
  '';

  # Wheels are pre-compiled
  buildPhase = attrs.buildPhase or ":";
  installCheckPhase = attrs.checkPhase or ":";

  # Wheels don't have any checks to run
  doCheck = attrs.doCheck or false;
}
