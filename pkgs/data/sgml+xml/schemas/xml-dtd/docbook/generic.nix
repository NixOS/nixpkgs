{
  lib,
  stdenv,
  unzip,
  fetchurl,
  findXMLCatalogs,
  src ? fetchurl {
    inherit hash url;
  },
  version,
  hash ? "",
  url ? "https://www.oasis-open.org/docbook/xml/${version}/docbook-xml-${version}.zip",
  postInstall ? "true",
}:

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
