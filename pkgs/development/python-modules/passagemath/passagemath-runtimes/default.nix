{
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

  meta.description = "Runtime configuration packages for PassageMath";
}
