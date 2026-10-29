{
  pname,
  version,
  src,
  meta,
  passthru ? { },
  stdenvNoCC,
  _7zz,
}:

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    meta
    passthru
    ;

  # dmg is APFS formatted
  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -a WeChat.app $out/Applications

    runHook postInstall
  '';
}
