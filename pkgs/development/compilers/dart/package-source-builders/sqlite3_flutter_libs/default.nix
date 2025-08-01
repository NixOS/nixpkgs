{
  stdenv,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "sqlite3_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    cp ${./CMakeLists.txt} linux/CMakeLists.txt
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
