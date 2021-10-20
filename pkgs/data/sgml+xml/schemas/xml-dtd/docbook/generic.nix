{ lib, stdenv, unzip, src, name, postInstall ? "true", meta ? {}, findXMLCatalogs }:

stdenv.mkDerivation {
  inherit src name postInstall;

  nativeBuildInputs = [unzip];
  propagatedNativeBuildInputs = [ findXMLCatalogs ];

  unpackPhase = ''
    mkdir -p $out/xml/dtd/docbook
    cd $out/xml/dtd/docbook
    unpackFile $src
  '';

  installPhase = ''
    find . -type f -exec chmod -x {} \;
    runHook postInstall
  '';

  meta = meta // {
    platforms = lib.platforms.unix;
  };
}
