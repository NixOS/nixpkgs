{
  pname,
  version,
  src,
  passthru,
  meta,

  stdenv,
  cacert,
  makeWrapper,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/libexec/tuple

    makeWrapper $out/libexec/tuple $out/bin/tuple \
      --set-default SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt

    runHook postInstall
  '';
}
