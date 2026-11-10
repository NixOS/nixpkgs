{
  stdenvNoCC,
  fetchurl,
  _7zz,

  passthru,
  pname,
  meta,
  ...
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname;

  inherit (finalAttrs.passthru.source) version;
  src = fetchurl finalAttrs.passthru.source.src;

  strictDeps = true;
  __structuredAttrs = true;

  # dmg is APFS formatted
  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -a WeChat.app $out/Applications

    runHook postInstall
  '';

  passthru = passthru finalAttrs;

  meta = meta finalAttrs;
})
