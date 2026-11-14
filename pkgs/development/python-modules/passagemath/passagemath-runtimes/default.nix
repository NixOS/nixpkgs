{
  lib,
  buildPythonPackage,
  passagemath-runtime-fflas-ffpack,
  passagemath-runtime-gap,
  passagemath-runtime-givaro,
  passagemath-runtime-linbox,
  passagemath-runtime-singular,
}:

buildPythonPackage {
  pname = "passagemath-runtimes";
  version = "10.8.13";

  pyproject = false;
  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    runHook postInstall
  '';

  dependencies = [
    passagemath-runtime-fflas-ffpack
    passagemath-runtime-gap
    passagemath-runtime-givaro
    passagemath-runtime-linbox
    passagemath-runtime-singular
  ];

  meta = {
    description = "Runtime configuration packages for PassageMath";
    longDescription = ''
      Collects the Nix runtime configuration packages for PassageMath, providing
      the paths to FFLAS-FFPACK, GAP, Givaro, LinBox, and Singular through
      `sage.config`.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
  };
}
