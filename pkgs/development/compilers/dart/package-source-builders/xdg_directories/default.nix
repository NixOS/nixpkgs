{
  stdenv,
  xdg-user-dirs,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "xdg_directories";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    substituteInPlace ./lib/xdg_directories.dart \
      --replace-fail "'xdg-user-dir'," "'${xdg-user-dirs}/bin/xdg-user-dir',"
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
