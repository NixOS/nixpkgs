{
  lib,
  stdenv,
  mpv-unwrapped,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "media_kit";
  inherit version src;
  inherit (src) passthru;

  dontBuild = true;

  postPatch = ''
    pushd '${src.passthru.packageRoot}'
    substituteInPlace lib/src/player/native/core/native_library.dart \
      --replace-fail "Platform.environment['LIBMPV_LIBRARY_PATH']" '"${lib.getLib mpv-unwrapped}/lib/libmpv.so"'
    popd
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./ -T "$out/"

    runHook postInstall
  '';
}
