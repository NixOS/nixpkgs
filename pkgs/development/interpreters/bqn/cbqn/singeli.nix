{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "singeli";
  version = "unstable-2023-11-22";

  src = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "Singeli";
    rev = "528faaf9e2a7f4f3434365bcd91d6c18c87c4f08";
    hash = "sha256-/z1KHqflCqPGC9JU80jtgqdk2mkX06eWSziuf4TU4TM=";
  };

  dontConfigure = true;
  # The CBQN derivation will build Singeli, here we just provide the source files.
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dev
    cp -r $src $out/dev

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/mlochbaum/Singeli";
    description = "A metaprogramming DSL for SIMD";
    license = licenses.isc;
    maintainers = with maintainers; [
      AndersonTorres
      sternenseemann
      synthetica
      shnarazk
      detegr
    ];
    platforms = platforms.all;
  };
}
