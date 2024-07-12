{ lib, stdenv, unzip, src, version, postInstall ? "true", findXMLCatalogs }:

stdenv.mkDerivation {
  inherit version src postInstall;
  pname = "docbook-xml";

  nativeBuildInputs = [ unzip ];
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

  meta = {
    branch = version;
    platforms = lib.platforms.unix;
  };
}
