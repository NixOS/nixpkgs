{
  lib,
  fetchurl,
  libxml2,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xhtml1";
  version = "20020801";

  src =
    let
      year = builtins.substring 0 4 finalAttrs.version;
    in
    fetchurl {
      url = "https://www.w3.org/TR/${year}/REC-xhtml1-${finalAttrs.version}/xhtml1.tgz";
      hash = "sha256-FI6ezLXJEiK18MBzWRdMoN8b10g0orrkxuV8EBNqIGc=";
    };

  nativeBuildInputs = [ libxml2 ];

  installPhase = lib.concatStringsSep "\n" [
    ''
      runHook preInstall
    ''

    ''
      mkdir -p $out/xml/dtd/xhtml1/
      cp DTD/*.ent DTD/*.dtd $out/xml/dtd/xhtml1/
    ''
    # Generate XML catalog
    ''
      catalog=$out/xml/dtd/xhtml1/catalog.xml
      xmlcatalog --noout --create $catalog
      grep PUBLIC DTD/*.soc | while read x; do
        eval a=($x)
        xmlcatalog --noout --add public "''${a[1]}" "''${a[2]}" $catalog
      done
    ''

    ''
      runHook postInstall
    ''
  ];

  meta = {
    homepage = "https://www.w3.org/TR/xhtml1/";
    description = "DTDs for XHTML 1.0, the Extensible HyperText Markup Language";
    license = lib.licenses.free; # https://www.w3.org/Consortium/Legal/copyright-software-19980720
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
