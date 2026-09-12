{
  stdenv,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "sqlite3_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    pushd ${src.passthru.packageRoot}
    cp ${./CMakeLists.txt} linux/CMakeLists.txt
    popd
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
